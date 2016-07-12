From: Paul Moore <paul@paul-moore.com>
Subject: Re: [PATCH] capabilities: audit capability use
Date: Tue, 12 Jul 2016 18:00:06 -0400
Message-ID: <CAHC9VhRjM6FxTrrbFPLu3eupzfMZOWCinHprPye0g0Gq5kuWcQ@mail.gmail.com>
References: <1468235672-3745-1-git-send-email-toiwoton@gmail.com>
 <87vb0bbzyo.fsf@x220.int.ebiederm.org> <ab56ac20-1d56-714c-eb54-9a43db496526@gmail.com>
 <878tx79et8.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Return-path: <linux-security-module-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=ZCr/7VfoAL31AjPb96bBme2qB2EpDVIT845f3OfBkhY=;
        b=YTs0sWWYjy/fHb7vVyDWhQu7/srkng9fSnrg0QT2mVpJJJ+Gt369W8ADHZ2JyLgr4Z
         jgPnIlYq3NCClTi3rbaVTfCIG6vH/Z07DmRxYalPt6U6yDTTvno2y9449yewZsCYEuoB
         EWv8/fZ3f9gwT0HGSKFNiYXGRYU06XC0dAx9jilnd8Zv9CvZMxSxhpqMhX4nb9AwIMpD
         N47+0n7ftIy6eK49VfkHJ5jiyzYtJd69WAVnt5LSb3DRVjPLmTZK2bTzKn/kZzFW0cG8
         X95hf2jgmOdehTghUWvQcG1+4N9K9kZXP3dwlMrbkwmuUJ7ysznf3o45htXWQFiru6Ff
         v1Iw==
In-Reply-To: <878tx79et8.fsf@x220.int.ebiederm.org>
Sender: owner-linux-security-module@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Topi Miettinen <toiwoton@gmail.com>, linux-kernel@vger.kernel.org, pmladek@suse.com, luto@kernel.org, serge@hallyn.com, keescook@chromium.org, Eric Paris <eparis@redhat.com>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, "moderated list:AUDIT SUBSYSTEM" <linux-audit@redhat.com>, "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>, "open list:CAPABILITIES" <linux-security-module@vger.kernel.org>

On Tue, Jul 12, 2016 at 9:16 AM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
> Not logging capabilities outside of the initial user namespace is
> certainly the conservative place to start, and what selinux does.

FYI, we added some basic userns capability smarts to SELinux in Linux 4.7.

  commit 8e4ff6f228e4722cac74db716e308d1da33d744f
  Author: Stephen Smalley <sds@tycho.nsa.gov>
  Date:   Fri Apr 8 13:52:00 2016 -0400

   selinux: distinguish non-init user namespace capability checks

   Distinguish capability checks against a target associated
   with the init user namespace versus capability checks against
   a target associated with a non-init user namespace by defining
   and using separate security classes for the latter.

   This is needed to support e.g. Chrome usage of user namespaces
   for the Chrome sandbox without needing to allow Chrome to also
   exercise capabilities on targets in the init user namespace.

   Suggested-by: Dan Walsh <dwalsh@redhat.com>
   Signed-off-by: Stephen Smalley <sds@tycho.nsa.gov>
   Signed-off-by: Paul Moore <paul@paul-moore.com>

-- 
paul moore
www.paul-moore.com
