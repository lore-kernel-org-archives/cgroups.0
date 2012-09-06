From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 06/10] cgroup: Assign subsystem IDs during compile
 time
Date: Thu, 6 Sep 2012 15:32:38 -0700
Message-ID: <20120906223238.GR29092@google.com>
References: <1345816904-21745-1-git-send-email-wagi@monom.org>
 <1345816904-21745-7-git-send-email-wagi@monom.org>
 <20120824233810.GT21325@google.com>
 <50390743.2090203@monom.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=Hn6Ox+gF3ase+Jg8+KPZXypZFobt81gZf8NRHpuhuSI=;
        b=LknGapNm9pbwmWs0usvixMRdgPa7ejCKJsiaVGuYed6GA9dlrpaiDPgr39HRwYdVzW
         WEPSFHfoBqh5kKFfDXp46QmwZNiPwNCXq6AsluOfGaYQF0JAHeZBDk+S+vcRwjKkv+4y
         etvoZLsL0KQ8qSx/OMWzzoyRtSndqI14rFaBxSC/MuSCMsMeZCZXtKOWQ4LxzxBBeRRr
         98KJxgivycjZtyz2DzNikYx9pY+ATfjodBz3/d8AWaoDKLWCaVyTR1JZYfBM1xkFXwFJ
         JvZLMty5HqsMEIAg3EsHah0SAeZzqk3F8aIYtGh3xblaTH9FHE2y7JNHJj1A2E9h3hLa
         dtzg==
Content-Disposition: inline
In-Reply-To: <50390743.2090203-kQCPcA+X3s7YtjvyW6yDsg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Daniel Wagner <wagi-kQCPcA+X3s7YtjvyW6yDsg@public.gmane.org>
Cc: netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Gao feng <gaofeng-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Jamal Hadi Salim <jhs-jkUAjuhPggJWk0Htik3J/w@public.gmane.org>, John Fastabend <john.r.fastabend-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Neil Horman <nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org>

Hello, Daniel.

On Sat, Aug 25, 2012 at 07:11:31PM +0200, Daniel Wagner wrote:
> On 25.08.2012 01:38, Tejun Heo wrote:
> >>task_cls_classid() and task_netprioidx() (when built as
> >>module) are protected by a jump label and therefore we can
> >>simply replace the subsystem index lookup with the enum.
> >
> >Can we put these in a separate patch?  ie. The first patch makes all
> >subsys IDs constant and then patches to simplify users.
> 
> Wouldn't this break bisection? I merged this step so that all steps
> in this series are able to compile and run.

I don't see why it should but maybe I'm missing something.  If so,
please enlighten me.

> >>+#define IS_SUBSYS_ENABLED(option) IS_MODULE(option)
> >>+#include <linux/cgroup_subsys.h>
> >>+#undef IS_SUBSYS_ENABLED
> >>+
> >
> >Why do we need to segregate in-kernel and modular ones at all?  What's
> >wrong with just defining them in one go?
> 
> I have done that but the result was a panic. There seems some code
> which expects this ordering. Let me dig into this and fix it.

Yes, please.

> >Hmm... patch sequence looks odd to me.  If you first make all IDs
> >constant, you can first remove module specific ones and then later add
> >jump labels as separate patches.  Wouldn't that be simpler?
> 
> As said above, I tried to keep all steps usable so bisection would
> work. I think your steps would lead to non working versions of the
> kernel.

Hmmm... Yes, it should be bisectable but again I don't see why being
biesectable interferes with the patch ordering here.

Thanks.

-- 
tejun
