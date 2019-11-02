From: Damian Tometzki <damian.tometzki@familie-tometzki.de>
Subject: Re: [PATCH] mm/memcontrol: update documentation about invoking oom
 killer
Date: Sat, 2 Nov 2019 17:28:21 +0100
Message-ID: <20191102162821.GB19103@freebsd.familie-tometzki.de>
References: <157270779336.1961.6528158720593572480.stgit@buzz>
 <20191102160252.GA19103@freebsd.familie-tometzki.de>
 <5c85a690-4ed7-91bb-30b5-c40174534a27@yandex-team.ru>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=familie-tometzki.de; s=google;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=KOhsT7U/lVZ/UH322QdKvvhT18+Y7E093E16VQv4bmc=;
        b=FQGV/w2NMVmH2cCpUK6iZSzjs3/ZDSx499CKDOmisKZvMfau0WOjwa7xQZHmRcYcKS
         o1AW1A6TgbMbIewZ1YpprbUpNnQRqyKwNvix2Qk7p0pu8yuPJJv4rqPlSG9u7/fnU9b6
         dH17bsx9nKMMCfeiZbG8pGQP9sVIdHBFeFhCE18vIprrmilLQ0OZoPcXDqqMvIuOvYUH
         LpEyAxIjNbUfOcCH5IPyBif+V90waJpLRxBucAxoFJkqaYiuKP+kGAcd52ghW56Kh6N9
         nSzuJaRfrZ2s/Lxa5Ns50fBh7Zy7ERY6UE3JPeKpWrCexBHjpRuTA3GW7OlTs5olyW2h
         iV5Q==
Content-Disposition: inline
In-Reply-To: <5c85a690-4ed7-91bb-30b5-c40174534a27@yandex-team.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Michal Hocko <mhocko@suse.com>

On Sat, 02. Nov 19:14, Konstantin Khlebnikov wrote:
> 
> 
> On 02/11/2019 19.02, Damian Tometzki wrote:
> > On Sat, 02. Nov 18:16, Konstantin Khlebnikov wrote:
> >> Since commit 29ef680ae7c2 ("memcg, oom: move out_of_memory back to the
> >> charge path") memcg invokes oom killer not only for user page-faults.
> >> This means 0-order allocation will either succeed or task get killed.
> >>
> >> Fixes: 8e675f7af507 ("mm/oom_kill: count global and memory cgroup oom kills")
> >> Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
> >> ---
> >>   Documentation/admin-guide/cgroup-v2.rst |    9 +++++++--
> >>   1 file changed, 7 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
> >> index 5361ebec3361..eb47815e137b 100644
> >> --- a/Documentation/admin-guide/cgroup-v2.rst
> >> +++ b/Documentation/admin-guide/cgroup-v2.rst
> >> @@ -1219,8 +1219,13 @@ PAGE_SIZE multiple when read back.
> >>   
> >>   		Failed allocation in its turn could be returned into
> >>   		userspace as -ENOMEM or silently ignored in cases like
> >> -		disk readahead.  For now OOM in memory cgroup kills
> >> -		tasks iff shortage has happened inside page fault.
> >> +		disk readahead.
> >> +
> >> +		Before 4.19 OOM in memory cgroup killed tasks iff
> > Hello Konstantin,
> > 
> > iff --> if :-)
> > 
> 
> This "iff" is shortened "if and only if".
> https://en.wikipedia.org/wiki/If_and_only_if

good to know :-)

> 
> > Best regards
> > Damian
> > 
> > 
> >> +		shortage has happened inside page fault, random
> >> +		syscall may fail with ENOMEM or EFAULT. Since 4.19
> >> +		failed memory cgroup allocation invokes oom killer and
> >> +		keeps retrying until it succeeds.
> >>   
> >>   		This event is not raised if the OOM killer is not
> >>   		considered as an option, e.g. for failed high-order
> >>
