From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 14/15] kernel: convert futex_pi_state.refcount from
 atomic_t to refcount_t
Date: Fri, 7 Jul 2017 13:11:30 +0200
Message-ID: <20170707111130.4vntze6ixqi4tkct@hirez.programming.kicks-ass.net>
References: <1499418269-3686-1-git-send-email-elena.reshetova@intel.com>
 <1499418269-3686-15-git-send-email-elena.reshetova@intel.com>
 <20170707092603.rmt4ne4c75k5qg56@hirez.programming.kicks-ass.net>
 <2236FBA76BA1254E88B949DDB74E612B6FF21DBE@IRSMSX102.ger.corp.intel.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=dR+eNtHxe5AEniCq4zFEbG/V3YHXZjiRdefkhI84djo=; b=FwPxcqWtNzMhcHPJeNaMs5Fg3
        2x37YzKdnZIEXkbnHBjnSSyb6+8wiSzkyHVHWXUQiG7mpoQSU49qXyGycB2cpGWYjk6NpaE2RY75I
        T3dQrY54MJZJa6H6kZ0fbTkFZ7ik4lQDeyINyN8yqo306pPlu7IQ8ZBybr2ND/gyZBqOTqFVpx69A
        VZBx68j93xnMGdp2GU6l4XxEwkGcUxDYwB41oBgX6QaT/b/trB/BdMIv3IXFQwaF46XnOOCgwjoJf
        vcZiOv/53bWAhNG9PxmIYSFbKzJ5dOSh24YVq/j1/kbOxwdrXSi/R609lyA7cnTNV16anMq8VzxXZ
    
Content-Disposition: inline
In-Reply-To: <2236FBA76BA1254E88B949DDB74E612B6FF21DBE-kPTMFJFq+rFP9JyJpTNKArfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Reshetova, Elena" <elena.reshetova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-audit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <linux-audit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org" <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org" <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, "tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org" <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, "lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org" <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "alexander.shishkin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org" <alexander.shishkin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, "eparis-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <eparis-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org" <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "arnd-r2nGTMty4D4@public.gmane.org" <arnd-r2nGTMty4D4@public.gmane.org>, "luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <lut>

On Fri, Jul 07, 2017 at 10:24:20AM +0000, Reshetova, Elena wrote:

> It is not so trivial as you might think. Unless right  person shows up
> as maintainer/supporter when I run get_maintainer script, 

In this case though it should:

FUTEX SUBSYSTEM
M:      Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
M:      Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
R:      Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
R:      Darren Hart <dvhart-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
L:      linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
T:      git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git locking/core
S:      Maintained
F:      kernel/futex.c
F:      kernel/futex_compat.c
F:      include/asm-generic/futex.h
F:      include/linux/futex.h
F:      include/uapi/linux/futex.h
F:      tools/testing/selftests/futex/
F:      tools/perf/bench/futex*
F:      Documentation/*futex*
