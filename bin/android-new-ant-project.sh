#!/bin/bash

TARGET=android-17

if [ ! $# -eq 1 ] ; then
    echo "Need a name for the project."
    exit 1
fi
PROJ=$1

cd ~/src/android
if [ -e $PROJ ] ; then
    echo "Directory $PROJ already exists."
    exit 1
fi

android create project --target $TARGET --name $PROJ --path $PROJ --activity ${PROJ^} --package com.faux
cd $PROJ

cp -r ~/android/android-sdk-linux/extras/google/google_play_services/libproject/google-play-services_lib libs
cd libs/google-play-services_lib
android update project --path . --target $TARGET
cd -
android update project --path . --target $TARGET --library libs/google-play-services_lib/

cat >> proguard-project.txt <<EOF

-keep class * extends java.util.ListResourceBundle {
    protected Object[][] getContents();
}

-keep public class com.google.android.gms.common.internal.safeparcel.SafeParcelable {
    public static final *** NULL;
}

-keepnames @com.google.android.gms.common.annotation.KeepName class *
-keepclassmembernames class * {
    @com.google.android.gms.common.annotation.KeepName *;
}

-keepnames class * implements android.os.Parcelable {
    public static final ** CREATOR;
}
EOF

echo -e "bin/\ngen/\nlibs/\nlocal.properties" > .gitignore
git init .
git add .
git config user.email andreassen.kjell@gmail.com
git ci -m "New Android Ant project with Google Play Services."

#ant debug
#ant installd
