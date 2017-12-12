dynamicRequire = (path) ->
  return new Promise (accept, reject) ->
    switch path
      when 'views/AboutView' then require.ensure(['views/AboutView'], ((require) -> accept(require('views/AboutView'))), reject, 'AboutView')
      when 'views/HomeView' then require.ensure(['views/HomeView'], ((require) -> accept(require('views/HomeView'))), reject, 'HomeView')
      when 'views/account/MainAccountView' then require.ensure(['views/account/MainAccountView'], ((require) -> accept(require('views/account/MainAccountView'))), reject, 'account')
      when 'views/account/AccountSettingsRootView' then require.ensure(['views/account/AccountSettingsRootView'], ((require) -> accept(require('views/account/AccountSettingsRootView'))), reject, 'account')
      when 'views/account/UnsubscribeView' then require.ensure(['views/account/UnsubscribeView'], ((require) -> accept(require('views/account/UnsubscribeView'))), reject, 'account')
      when 'views/account/PaymentsView' then require.ensure(['views/account/PaymentsView'], ((require) -> accept(require('views/account/PaymentsView'))), reject, 'account')
      when 'views/account/SubscriptionView' then require.ensure(['views/account/SubscriptionView'], ((require) -> accept(require('views/account/SubscriptionView'))), reject, 'account')
      when 'views/account/InvoicesView' then require.ensure(['views/account/InvoicesView'], ((require) -> accept(require('views/account/InvoicesView'))), reject, 'account')
      when 'views/account/PrepaidView' then require.ensure(['views/account/PrepaidView'], ((require) -> accept(require('views/account/PrepaidView'))), reject, 'account')
      when 'views/admin/MainAdminView' then require.ensure(['views/admin/MainAdminView'], ((require) -> accept(require('views/admin/MainAdminView'))), reject, 'admin')
      when 'views/admin/CLAsView' then require.ensure(['views/admin/CLAsView'], ((require) -> accept(require('views/admin/CLAsView'))), reject, 'admin')
      when 'views/admin/AdminClassroomContentView' then require.ensure(['views/admin/AdminClassroomContentView'], ((require) -> accept(require('views/admin/AdminClassroomContentView'))), reject, 'admin')
      when 'views/admin/AdminClassroomLevelsView' then require.ensure(['views/admin/AdminClassroomLevelsView'], ((require) -> accept(require('views/admin/AdminClassroomLevelsView'))), reject, 'admin')
      when 'views/admin/AdminClassroomsProgressView' then require.ensure(['views/admin/AdminClassroomsProgressView'], ((require) -> accept(require('views/admin/AdminClassroomsProgressView'))), reject, 'admin')
      # when 'views/admin/DesignElementsView' then require.ensure(['views/admin/DesignElementsView'], ((require) -> accept(require('views/admin/DesignElementsView'))), reject, 'admin')
      when 'views/admin/FilesView' then require.ensure(['views/admin/FilesView'], ((require) -> accept(require('views/admin/FilesView'))), reject, 'admin')
      when 'views/admin/AnalyticsView' then require.ensure(['views/admin/AnalyticsView'], ((require) -> accept(require('views/admin/AnalyticsView'))), reject, 'admin')
      when 'views/admin/AnalyticsSubscriptionsView' then require.ensure(['views/admin/AnalyticsSubscriptionsView'], ((require) -> accept(require('views/admin/AnalyticsSubscriptionsView'))), reject, 'admin')
      when 'views/admin/AdminLevelHintsView' then require.ensure(['views/admin/AdminLevelHintsView'], ((require) -> accept(require('views/admin/AdminLevelHintsView'))), reject, 'admin')
      # when 'views/admin/LevelSessionsView' then require.ensure(['views/admin/LevelSessionsView'], ((require) -> accept(require('views/admin/LevelSessionsView'))), reject, 'admin')
      when 'views/admin/SchoolCountsView' then require.ensure(['views/admin/SchoolCountsView'], ((require) -> accept(require('views/admin/SchoolCountsView'))), reject, 'admin')
      when 'views/admin/SchoolLicensesView' then require.ensure(['views/admin/SchoolLicensesView'], ((require) -> accept(require('views/admin/SchoolLicensesView'))), reject, 'admin')
      when 'views/admin/BaseView' then require.ensure(['views/admin/BaseView'], ((require) -> accept(require('views/admin/BaseView'))), reject, 'admin')
      when 'views/admin/DemoRequestsView' then require.ensure(['views/admin/DemoRequestsView'], ((require) -> accept(require('views/admin/DemoRequestsView'))), reject, 'admin')
      when 'views/admin/TrialRequestsView' then require.ensure(['views/admin/TrialRequestsView'], ((require) -> accept(require('views/admin/TrialRequestsView'))), reject, 'admin')
      when 'views/admin/UserCodeProblemsView' then require.ensure(['views/admin/UserCodeProblemsView'], ((require) -> accept(require('views/admin/UserCodeProblemsView'))), reject, 'admin')
      when 'views/admin/PendingPatchesView' then require.ensure(['views/admin/PendingPatchesView'], ((require) -> accept(require('views/admin/PendingPatchesView'))), reject, 'admin')
      when 'views/admin/CodeLogsView' then require.ensure(['views/admin/CodeLogsView'], ((require) -> accept(require('views/admin/CodeLogsView'))), reject, 'admin')
      when 'views/admin/SkippedContactsView' then require.ensure(['views/admin/SkippedContactsView'], ((require) -> accept(require('views/admin/SkippedContactsView'))), reject, 'admin')
      when 'views/admin/OutcomeReportResultView' then require.ensure(['views/admin/OutcomeReportResultView'], ((require) -> accept(require('views/admin/OutcomeReportResultView'))), reject, 'admin')
      when 'views/admin/OutcomesReportView' then require.ensure(['views/admin/OutcomesReportView'], ((require) -> accept(require('views/admin/OutcomesReportView'))), reject, 'admin')
      when 'views/teachers/DynamicAPCSPView' then require.ensure(['views/teachers/DynamicAPCSPView'], ((require) -> accept(require('views/teachers/DynamicAPCSPView'))), reject, 'teachers')
      when 'views/artisans/ArtisansView' then require.ensure(['views/artisans/ArtisansView'], ((require) -> accept(require('views/artisans/ArtisansView'))), reject, 'artisans')
      when 'views/artisans/LevelTasksView' then require.ensure(['views/artisans/LevelTasksView'], ((require) -> accept(require('views/artisans/LevelTasksView'))), reject, 'artisans')
      when 'views/artisans/SolutionProblemsView' then require.ensure(['views/artisans/SolutionProblemsView'], ((require) -> accept(require('views/artisans/SolutionProblemsView'))), reject, 'artisans')
      # when 'views/artisans/ThangTasksView' then require.ensure(['views/artisans/ThangTasksView'], ((require) -> accept(require('views/artisans/ThangTasksView'))), reject, 'artisans')
      when 'views/artisans/LevelConceptMap' then require.ensure(['views/artisans/LevelConceptMap'], ((require) -> accept(require('views/artisans/LevelConceptMap'))), reject, 'artisans')
      when 'views/artisans/LevelGuidesView' then require.ensure(['views/artisans/LevelGuidesView'], ((require) -> accept(require('views/artisans/LevelGuidesView'))), reject, 'artisans')
      when 'views/artisans/StudentSolutionsView' then require.ensure(['views/artisans/StudentSolutionsView'], ((require) -> accept(require('views/artisans/StudentSolutionsView'))), reject, 'artisans')
      when 'views/artisans/TagTestView' then require.ensure(['views/artisans/TagTestView'], ((require) -> accept(require('views/artisans/TagTestView'))), reject, 'artisans')
      when 'views/CLAView' then require.ensure(['views/CLAView'], ((require) -> accept(require('views/CLAView'))), reject, 'CLAView')
      when 'views/clans/ClansView' then require.ensure(['views/clans/ClansView'], ((require) -> accept(require('views/clans/ClansView'))), reject, 'clans')
      when 'views/clans/ClanDetailsView' then require.ensure(['views/clans/ClanDetailsView'], ((require) -> accept(require('views/clans/ClanDetailsView'))), reject, 'clans')
      when 'views/CommunityView' then require.ensure(['views/CommunityView'], ((require) -> accept(require('views/CommunityView'))), reject, 'CommunityView')
      when 'views/contribute/MainContributeView' then require.ensure(['views/contribute/MainContributeView'], ((require) -> accept(require('views/contribute/MainContributeView'))), reject, 'contribute')
      when 'views/contribute/AdventurerView' then require.ensure(['views/contribute/AdventurerView'], ((require) -> accept(require('views/contribute/AdventurerView'))), reject, 'contribute')
      when 'views/contribute/AmbassadorView' then require.ensure(['views/contribute/AmbassadorView'], ((require) -> accept(require('views/contribute/AmbassadorView'))), reject, 'contribute')
      when 'views/contribute/ArchmageView' then require.ensure(['views/contribute/ArchmageView'], ((require) -> accept(require('views/contribute/ArchmageView'))), reject, 'contribute')
      when 'views/contribute/ArtisanView' then require.ensure(['views/contribute/ArtisanView'], ((require) -> accept(require('views/contribute/ArtisanView'))), reject, 'contribute')
      when 'views/contribute/DiplomatView' then require.ensure(['views/contribute/DiplomatView'], ((require) -> accept(require('views/contribute/DiplomatView'))), reject, 'contribute')
      when 'views/contribute/ScribeView' then require.ensure(['views/contribute/ScribeView'], ((require) -> accept(require('views/contribute/ScribeView'))), reject, 'contribute')
      # when 'views/docs/ComponentsDocumentationView' then require.ensure(['views/docs/ComponentsDocumentationView'], ((require) -> accept(require('views/docs/ComponentsDocumentationView'))), reject, 'docs')
      # when 'views/docs/SystemsDocumentationView' then require.ensure(['views/docs/SystemsDocumentationView'], ((require) -> accept(require('views/docs/SystemsDocumentationView'))), reject, 'docs')
      when 'views/editor/achievement/AchievementSearchView' then require.ensure(['views/editor/achievement/AchievementSearchView'], ((require) -> accept(require('views/editor/achievement/AchievementSearchView'))), reject, 'editor')
      when 'views/editor/achievement/AchievementEditView' then require.ensure(['views/editor/achievement/AchievementEditView'], ((require) -> accept(require('views/editor/achievement/AchievementEditView'))), reject, 'editor')
      when 'views/editor/article/ArticleSearchView' then require.ensure(['views/editor/article/ArticleSearchView'], ((require) -> accept(require('views/editor/article/ArticleSearchView'))), reject, 'editor')
      when 'views/editor/article/ArticlePreviewView' then require.ensure(['views/editor/article/ArticlePreviewView'], ((require) -> accept(require('views/editor/article/ArticlePreviewView'))), reject, 'editor')
      when 'views/editor/article/ArticleEditView' then require.ensure(['views/editor/article/ArticleEditView'], ((require) -> accept(require('views/editor/article/ArticleEditView'))), reject, 'editor')
      when 'views/editor/level/LevelSearchView' then require.ensure(['views/editor/level/LevelSearchView'], ((require) -> accept(require('views/editor/level/LevelSearchView'))), reject, 'editor')
      when 'views/editor/level/LevelEditView' then require.ensure(['views/editor/level/LevelEditView'], ((require) -> accept(require('views/editor/level/LevelEditView'))), reject, 'editor')
      when 'views/editor/thang/ThangTypeSearchView' then require.ensure(['views/editor/thang/ThangTypeSearchView'], ((require) -> accept(require('views/editor/thang/ThangTypeSearchView'))), reject, 'editor')
      when 'views/editor/thang/ThangTypeEditView' then require.ensure(['views/editor/thang/ThangTypeEditView'], ((require) -> accept(require('views/editor/thang/ThangTypeEditView'))), reject, 'editor')
      when 'views/editor/campaign/CampaignEditorView' then require.ensure(['views/editor/campaign/CampaignEditorView'], ((require) -> accept(require('views/editor/campaign/CampaignEditorView'))), reject, 'editor')
      when 'views/editor/poll/PollSearchView' then require.ensure(['views/editor/poll/PollSearchView'], ((require) -> accept(require('views/editor/poll/PollSearchView'))), reject, 'editor')
      when 'views/editor/poll/PollEditView' then require.ensure(['views/editor/poll/PollEditView'], ((require) -> accept(require('views/editor/poll/PollEditView'))), reject, 'editor')
      # when 'views/editor/ThangTasksView' then require.ensure(['views/editor/ThangTasksView'], ((require) -> accept(require('views/editor/ThangTasksView'))), reject, 'editor')
      when 'views/editor/verifier/VerifierView' then require.ensure(['views/editor/verifier/VerifierView'], ((require) -> accept(require('views/editor/verifier/VerifierView'))), reject, 'editor')
      when 'views/editor/verifier/i18nVerifierView' then require.ensure(['views/editor/verifier/i18nVerifierView'], ((require) -> accept(require('views/editor/verifier/i18nVerifierView'))), reject, 'editor')
      when 'views/editor/course/CourseSearchView' then require.ensure(['views/editor/course/CourseSearchView'], ((require) -> accept(require('views/editor/course/CourseSearchView'))), reject, 'editor')
      when 'views/editor/course/CourseEditView' then require.ensure(['views/editor/course/CourseEditView'], ((require) -> accept(require('views/editor/course/CourseEditView'))), reject, 'editor')
      when 'views/i18n/I18NHomeView' then require.ensure(['views/i18n/I18NHomeView'], ((require) -> accept(require('views/i18n/I18NHomeView'))), reject, 'i18n')
      when 'views/i18n/I18NEditThangTypeView' then require.ensure(['views/i18n/I18NEditThangTypeView'], ((require) -> accept(require('views/i18n/I18NEditThangTypeView'))), reject, 'i18n')
      when 'views/i18n/I18NEditComponentView' then require.ensure(['views/i18n/I18NEditComponentView'], ((require) -> accept(require('views/i18n/I18NEditComponentView'))), reject, 'i18n')
      when 'views/i18n/I18NEditLevelView' then require.ensure(['views/i18n/I18NEditLevelView'], ((require) -> accept(require('views/i18n/I18NEditLevelView'))), reject, 'i18n')
      when 'views/i18n/I18NEditAchievementView' then require.ensure(['views/i18n/I18NEditAchievementView'], ((require) -> accept(require('views/i18n/I18NEditAchievementView'))), reject, 'i18n')
      when 'views/i18n/I18NEditCampaignView' then require.ensure(['views/i18n/I18NEditCampaignView'], ((require) -> accept(require('views/i18n/I18NEditCampaignView'))), reject, 'i18n')
      when 'views/i18n/I18NEditPollView' then require.ensure(['views/i18n/I18NEditPollView'], ((require) -> accept(require('views/i18n/I18NEditPollView'))), reject, 'i18n')
      when 'views/i18n/I18NEditCourseView' then require.ensure(['views/i18n/I18NEditCourseView'], ((require) -> accept(require('views/i18n/I18NEditCourseView'))), reject, 'i18n')
      when 'views/i18n/I18NEditProductView' then require.ensure(['views/i18n/I18NEditProductView'], ((require) -> accept(require('views/i18n/I18NEditProductView'))), reject, 'i18n')
      when 'views/user/IdentifyView' then require.ensure(['views/user/IdentifyView'], ((require) -> accept(require('views/user/IdentifyView'))), reject, 'user')
      when 'views/account/IsraelSignupView' then require.ensure(['views/account/IsraelSignupView'], ((require) -> accept(require('views/account/IsraelSignupView'))), reject, 'account')
      when 'views/LegalView' then require.ensure(['views/LegalView'], ((require) -> accept(require('views/LegalView'))), reject, 'LegalView')
      when 'views/play/CampaignView' then require.ensure(['views/play/CampaignView'], ((require) -> accept(require('views/play/CampaignView'))), reject, 'play')
      when 'views/ladder/LadderView' then require.ensure(['views/ladder/LadderView'], ((require) -> accept(require('views/ladder/LadderView'))), reject, 'ladder')
      when 'views/ladder/MainLadderView' then require.ensure(['views/ladder/MainLadderView'], ((require) -> accept(require('views/ladder/MainLadderView'))), reject, 'ladder')
      when 'views/play/level/PlayLevelView' then require.ensure(['views/play/level/PlayLevelView'], ((require) -> accept(require('views/play/level/PlayLevelView'))), reject, 'play')
      when 'views/play/level/PlayGameDevLevelView' then require.ensure(['views/play/level/PlayGameDevLevelView'], ((require) -> accept(require('views/play/level/PlayGameDevLevelView'))), reject, 'play')
      when 'views/play/level/PlayWebDevLevelView' then require.ensure(['views/play/level/PlayWebDevLevelView'], ((require) -> accept(require('views/play/level/PlayWebDevLevelView'))), reject, 'play')
      when 'views/play/SpectateView' then require.ensure(['views/play/SpectateView'], ((require) -> accept(require('views/play/SpectateView'))), reject, 'play')
      when 'views/PremiumFeaturesView' then require.ensure(['views/PremiumFeaturesView'], ((require) -> accept(require('views/PremiumFeaturesView'))), reject, 'PremiumFeaturesView')
      when 'views/PrivacyView' then require.ensure(['views/PrivacyView'], ((require) -> accept(require('views/PrivacyView'))), reject, 'PrivacyView')
      when 'views/courses/CoursesView' then require.ensure(['views/courses/CoursesView'], ((require) -> accept(require('views/courses/CoursesView'))), reject, 'courses')
      when 'views/courses/CoursesUpdateAccountView' then require.ensure(['views/courses/CoursesUpdateAccountView'], ((require) -> accept(require('views/courses/CoursesUpdateAccountView'))), reject, 'courses')
      when 'views/courses/ProjectGalleryView' then require.ensure(['views/courses/ProjectGalleryView'], ((require) -> accept(require('views/courses/ProjectGalleryView'))), reject, 'courses')
      when 'views/courses/ClassroomView' then require.ensure(['views/courses/ClassroomView'], ((require) -> accept(require('views/courses/ClassroomView'))), reject, 'courses')
      when 'views/courses/CourseDetailsView' then require.ensure(['views/courses/CourseDetailsView'], ((require) -> accept(require('views/courses/CourseDetailsView'))), reject, 'courses')
      when 'views/courses/TeacherClassesView' then require.ensure(['views/courses/TeacherClassesView'], ((require) -> accept(require('views/courses/TeacherClassesView'))), reject, 'courses')
      when 'views/teachers/TeacherStudentView' then require.ensure(['views/teachers/TeacherStudentView'], ((require) -> accept(require('views/teachers/TeacherStudentView'))), reject, 'teachers')
      when 'views/courses/TeacherClassView' then require.ensure(['views/courses/TeacherClassView'], ((require) -> accept(require('views/courses/TeacherClassView'))), reject, 'courses')
      when 'views/courses/TeacherCoursesView' then require.ensure(['views/courses/TeacherCoursesView'], ((require) -> accept(require('views/courses/TeacherCoursesView'))), reject, 'courses')
      when 'views/teachers/TeacherCourseSolutionView' then require.ensure(['views/teachers/TeacherCourseSolutionView'], ((require) -> accept(require('views/teachers/TeacherCourseSolutionView'))), reject, 'teachers')
      when 'views/teachers/RequestQuoteView' then require.ensure(['views/teachers/RequestQuoteView'], ((require) -> accept(require('views/teachers/RequestQuoteView'))), reject, 'teachers')
      when 'views/courses/EnrollmentsView' then require.ensure(['views/courses/EnrollmentsView'], ((require) -> accept(require('views/courses/EnrollmentsView'))), reject, 'courses')
      when 'views/teachers/ResourceHubView' then require.ensure(['views/teachers/ResourceHubView'], ((require) -> accept(require('views/teachers/ResourceHubView'))), reject, 'teachers')
      when 'views/teachers/ApCsPrinciplesView' then require.ensure(['views/teachers/ApCsPrinciplesView'], ((require) -> accept(require('views/teachers/ApCsPrinciplesView'))), reject, 'teachers')
      when 'views/teachers/MarkdownResourceView' then require.ensure(['views/teachers/MarkdownResourceView'], ((require) -> accept(require('views/teachers/MarkdownResourceView'))), reject, 'teachers')
      when 'views/teachers/CreateTeacherAccountView' then require.ensure(['views/teachers/CreateTeacherAccountView'], ((require) -> accept(require('views/teachers/CreateTeacherAccountView'))), reject, 'teachers')
      when 'views/teachers/StarterLicenseUpsellView' then require.ensure(['views/teachers/StarterLicenseUpsellView'], ((require) -> accept(require('views/teachers/StarterLicenseUpsellView'))), reject, 'teachers')
      when 'views/teachers/ConvertToTeacherAccountView' then require.ensure(['views/teachers/ConvertToTeacherAccountView'], ((require) -> accept(require('views/teachers/ConvertToTeacherAccountView'))), reject, 'teachers')
      when 'views/TestView' then require.ensure(['views/TestView'], ((require) -> accept(require('views/TestView'))), reject, 'TestView')
      when 'views/user/MainUserView' then require.ensure(['views/user/MainUserView'], ((require) -> accept(require('views/user/MainUserView'))), reject, 'user')
      when 'views/user/EmailVerifiedView' then require.ensure(['views/user/EmailVerifiedView'], ((require) -> accept(require('views/user/EmailVerifiedView'))), reject, 'user')
      when 'views/NotFoundView' then require.ensure(['views/NotFoundView'], ((require) -> accept(require('views/NotFoundView'))), reject, 'NotFoundView')
      when 'views/teachers/RestrictedToTeachersView' then require.ensure(['views/teachers/RestrictedToTeachersView'], ((require) -> accept(require('views/teachers/RestrictedToTeachersView'))), reject, 'RestrictedToTeachersView')
      when 'views/courses/RestrictedToStudentsView' then require.ensure(['views/courses/RestrictedToStudentsView'], ((require) -> accept(require('views/courses/RestrictedToStudentsView'))), reject, 'RestrictedToStudentsView')
      else
        throw new Error("Couldn't dynamically require that view! #{path}")

module.exports = dynamicRequire
