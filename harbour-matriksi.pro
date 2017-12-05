TARGET = harbour-matriksi

i18n_files.files = translations
i18n_files.path = /usr/share/$$TARGET

INSTALLS += i18n_files

CONFIG += sailfishapp

SOURCES += src/harbour-matriksi.cpp \
    src/settings.cpp

OTHER_FILES += qml/harbour-matriksi.qml \
    qml/cover/CoverPage.qml \
    qml/pages/FirstPage.qml \
    qml/pages/SecondPage.qml \
    rpm/harbour-matriksi.changes.in \
    rpm/harbour-matriksi.spec \
    rpm/harbour-matriksi.yaml \
    translations/*.ts \
    harbour-matriksi.desktop

SAILFISHAPP_ICONS = 86x86 108x108 128x128 256x256

CONFIG += sailfishapp_i18n

TRANSLATIONS += translations/harbour-matriksi.ts \
                translations/harbour-matriksi-es.ts \
                translations/harbour-matriksi-fi.ts \
                translations/harbour-matriksi-de.ts

DISTFILES += \
    qml/room.py \
    qml/user.py \
    qml/errors.py \
    qml/api.py \
    qml/requests/cacert.pem \
    icons/108x108/harbour-matriksi.png \
    icons/128x128/harbour-matriksi.png \
    icons/256x256/harbour-matriksi.png \
    icons/86x86/harbour-matriksi.png \
    qml/requests/packages/chardet/__init__.py \
    qml/requests/packages/chardet/big5freq.py \
    qml/requests/packages/chardet/big5prober.py \
    qml/requests/packages/chardet/chardetect.py \
    qml/requests/packages/chardet/chardistribution.py \
    qml/requests/packages/chardet/charsetgroupprober.py \
    qml/requests/packages/chardet/charsetprober.py \
    qml/requests/packages/chardet/codingstatemachine.py \
    qml/requests/packages/chardet/compat.py \
    qml/requests/packages/chardet/constants.py \
    qml/requests/packages/chardet/cp949prober.py \
    qml/requests/packages/chardet/escprober.py \
    qml/requests/packages/chardet/escsm.py \
    qml/requests/packages/chardet/eucjpprober.py \
    qml/requests/packages/chardet/euckrfreq.py \
    qml/requests/packages/chardet/euckrprober.py \
    qml/requests/packages/chardet/euctwfreq.py \
    qml/requests/packages/chardet/euctwprober.py \
    qml/requests/packages/chardet/gb2312freq.py \
    qml/requests/packages/chardet/gb2312prober.py \
    qml/requests/packages/chardet/hebrewprober.py \
    qml/requests/packages/chardet/jisfreq.py \
    qml/requests/packages/chardet/jpcntx.py \
    qml/requests/packages/chardet/langbulgarianmodel.py \
    qml/requests/packages/chardet/langcyrillicmodel.py \
    qml/requests/packages/chardet/langgreekmodel.py \
    qml/requests/packages/chardet/langhebrewmodel.py \
    qml/requests/packages/chardet/langhungarianmodel.py \
    qml/requests/packages/chardet/langthaimodel.py \
    qml/requests/packages/chardet/latin1prober.py \
    qml/requests/packages/chardet/mbcharsetprober.py \
    qml/requests/packages/chardet/mbcsgroupprober.py \
    qml/requests/packages/chardet/mbcssm.py \
    qml/requests/packages/chardet/sbcharsetprober.py \
    qml/requests/packages/chardet/sbcsgroupprober.py \
    qml/requests/packages/chardet/sjisprober.py \
    qml/requests/packages/chardet/universaldetector.py \
    qml/requests/packages/chardet/utf8prober.py \
    qml/requests/packages/urllib3/contrib/__init__.py \
    qml/requests/packages/urllib3/contrib/ntlmpool.py \
    qml/requests/packages/urllib3/contrib/pyopenssl.py \
    qml/requests/packages/urllib3/packages/ssl_match_hostname/__init__.py \
    qml/requests/packages/urllib3/packages/ssl_match_hostname/_implementation.py \
    qml/requests/packages/urllib3/packages/__init__.py \
    qml/requests/packages/urllib3/packages/ordered_dict.py \
    qml/requests/packages/urllib3/packages/six.py \
    qml/requests/packages/urllib3/__init__.py \
    qml/requests/packages/urllib3/_collections.py \
    qml/requests/packages/urllib3/connection.py \
    qml/requests/packages/urllib3/connectionpool.py \
    qml/requests/packages/urllib3/exceptions.py \
    qml/requests/packages/urllib3/fields.py \
    qml/requests/packages/urllib3/filepost.py \
    qml/requests/packages/urllib3/poolmanager.py \
    qml/requests/packages/urllib3/request.py \
    qml/requests/packages/urllib3/response.py \
    qml/requests/packages/urllib3/util.py \
    qml/requests/packages/__init__.py \
    qml/requests/__init__.py \
    qml/requests/adapters.py \
    qml/requests/api.py \
    qml/requests/auth.py \
    qml/requests/certs.py \
    qml/requests/compat.py \
    qml/requests/cookies.py \
    qml/requests/exceptions.py \
    qml/requests/hooks.py \
    qml/requests/models.py \
    qml/requests/sessions.py \
    qml/requests/status_codes.py \
    qml/requests/structures.py \
    qml/requests/utils.py \
    qml/__init__.py \
    qml/matriksi.py \
    qml/matrixclient.js \
    qml/client.py \
    qml/pyclient.py \
    qml/pages/eventWorker.js \
    qml/pages/Login.qml \
    qml/pages/SettingsPage.qml \
    qml/pages/UsersPage.qml \
    qml/pages/ChatPage.qml \
    qml/components/textdelegate/TextDelegate.qml \
    qml/components/about/CollaboratorsLabel.qml \
    qml/components/about/ThirdPartyLabel.qml \
    qml/components/textlabel/TextLabel.qml \
    qml/components/custom/ClickableLabel.qml \
    qml/components/custom/AvatarImage.qml \
    qml/components/translation/IconTextButton.qml \
    qml/pages/TextDelegateComponent.qml \
    qml/pages/MemberDelegate.qml \
    qml/pages/ThirdPartyPage.qml \
    qml/pages/DevelopersPage.qml \
    qml/pages/TranslationsPage.qml \
    qml/pages/AboutPage.qml \
    qml/pages/ImageDelegate.qml

HEADERS += \
    src/settings.h

RESOURCES += \
    resources.qrc
