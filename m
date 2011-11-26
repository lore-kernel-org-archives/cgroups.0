From: Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/4] Move part of cpuacct code
Date: Sat, 26 Nov 2011 05:21:13 -0800
Message-ID: <CAPM31RJoN2t+nUuap+FWLYoEx=EshU=v6Gy8JsxJAaichZFjcA@mail.gmail.com>
References: <1322184806-20421-1-git-send-email-glommer@parallels.com> <1322184806-20421-4-git-send-email-glommer@parallels.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding:x-system-of-record;
        bh=VaQR2/xyKswO/iylaePSIF/IOtfRZOo9AGWf8f5oG7s=;
        b=Z6mNLKowsLkmLgZZkn/nUoiZ3Fda2g7Lo9wiPmgj7bHPIbzZdzpQJJcARUa9jr0b5G
         chQUIoMdebZWULEnCJ8Q==
In-Reply-To: <1322184806-20421-4-git-send-email-glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org, daniel.lezcano-GANU6spQydw@public.gmane.org, a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org, jbottomley-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org

On Thu, Nov 24, 2011 at 5:33 PM, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org> =
wrote:
> This patch is just a preparation patch for the next one in the series=
=2E
> It moves the cpuacct structure definition and some helper functions e=
arly
> in the file so we can access its members from here on.
>
> Signed-off-by: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
> CC: Paul Tuner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> CC: Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>
> ---
> =A0kernel/sched.c | =A0 77 +++++++++++++++++++++++++++---------------=
-------------
> =A01 files changed, 38 insertions(+), 39 deletions(-)

Bad news -- You've run afoul of a massive file re-structuring conflict =
:(

All of sched has been refactored under "kernel/sched/"; sched.c and
friends don't exist anymore.

- Paul
--
To unsubscribe from this list: send the line "unsubscribe cgroups" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
