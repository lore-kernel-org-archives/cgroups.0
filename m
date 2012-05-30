From: Paul Turner <pjt@google.com>
Subject: Re: [PATCH v3 2/6] account guest time per-cgroup as well.
Date: Wed, 30 May 2012 03:46:13 -0700
Message-ID: <CAPM31RJjMZ4ZJP_=_nGLk8AeBvzZ+PhEpjXxEb2Ko_0f7dsdgg@mail.gmail.com>
References: <1338371317-5980-1-git-send-email-glommer@parallels.com>
 <1338371317-5980-3-git-send-email-glommer@parallels.com> <1338373947.26856.240.camel@twins>
 <4FC5F82B.6030404@parallels.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding:x-system-of-record;
        bh=zUnaBM7sMFQShXfBkb7RL3fCTzzWNGCBEJzP4PJzTJc=;
        b=AZCzrNMQmleHMFnsVpIzokC5W8nkR49IgtI/cUYjhE2CmFAe6Jxe0VprKjPvSBWGZV
         UeHWBHUjTNRm6rgIdF9/9jcwnVI6kDxpS7eRyTTHxAMcanhpp0BOyMzp2CzGzSfaB9Eb
         aenbfC8GEfCYQ8YiwScpknpGslcuPgCngDaCl1JPsFt5N6FHx4SBX+XoLQR7jKzfHUER
         2L8xyO3gBbaPU+41/0N70hO/1fmci7j3LIUmLwJ3+2yza2GoqjK8qHg30skYFDHP8lOj
         zfYbgln6Q/mVcDLMOJ+nalhWNLjs1mpQCE0FxvBrAvRpAbIcNx8n2+50WoZuj6IUMFsT
         oGmQ==
In-Reply-To: <4FC5F82B.6030404@parallels.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Glauber Costa <glommer@parallels.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, devel@openvz.org, Tejun Heo <tj@kernel.org>, "Eric W. Biederman" <ebiederm@xmission.com>, handai.szj@gmail.com, Andrew.Phillips@lmax.com, Serge Hallyn <serge.hallyn@canonical.com>

On Wed, May 30, 2012 at 3:36 AM, Glauber Costa <glommer@parallels.com> =
wrote:
> On 05/30/2012 02:32 PM, Peter Zijlstra wrote:
>>
>> On Wed, 2012-05-30 at 13:48 +0400, Glauber Costa wrote:
>>>
>>> > =A0We already track multiple tick statistics per-cgroup, using
>>> > =A0the task_group_account_field facility. This patch accounts
>>> > =A0guest_time in that manner as well.
>>
>> So this leaves IOWAIT and IDLE the only fields not using
>> task_group_account_field(), right?
>
>
> Yes, because they are essentially global, and their meaning is ill-de=
fined
> from within a cgroup.
>
> If you look further out in the patchset, I intend to export idle from=
 cpu,
> instead of cpuacct, because something that can be used as idle value =
is
> already computed anyway from the schedstats, so I'm just using it.
>
> iowait will be left blank for now. Me and Paul agreed last time we ta=
lked
> that it is not uber important to have iowait values per-cgroup.

Stronger:  it lacks a definition you can sanely measure without atomic
counters everywhere (similarly for group-idle).

> --
> To unsubscribe from this list: send the line "unsubscribe cgroups" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
