From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH v4] memcg: charge before adding to swapcache on swapin
Date: Fri, 5 Mar 2021 13:53:54 -0800
Message-ID: <CALvZod5oPTj8r6vKXVGgtKoXVaRWbRX9S2mLVtSnyysqtzr_ng@mail.gmail.com>
References: <20210305212639.775498-1-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GsmMJABHzjW2imdiPFuBeArH9DaQyKHwBF7blWrk06o=;
        b=VYmZTqRzqRfXYYbPq4vU9UkIKIyFebUXF+fHNRjhr3iifCoNKRu+HHXLMeqm3xZDYH
         i/gCvMdtE+8hqyPAwuxNSjW68kzaprBvJIaGcDgPw+YIXsLC3xeJezFFtsAEpTKdOx/l
         E56fv7ugEoJKKG17KZJjvavpZVmn3wZVN2pFQitux0AKhBjP0+5b9tL5zUPEgg1DYfvp
         kqViuMiNWrI04N0ARC+2m8FUediMH3GRg0Otv+JUML8gKufh33kbXSd/Y/kxBGPAOsJl
         uYraYW1I5R8fGG6MeY5DxqeGmVMhAFur0jBoZOhgMofoB1vh/obnYN37d7XtUsZlSAn6
         WBuw==
In-Reply-To: <20210305212639.775498-1-shakeelb@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hugh Dickins <hughd@google.com>, Johannes Weiner <hannes@cmpxchg.org>
Cc: Roman Gushchin <guro@fb.com>, Michal Hocko <mhocko@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Cgroups <cgroups@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>

On Fri, Mar 5, 2021 at 1:26 PM Shakeel Butt <shakeelb@google.com> wrote:
>
> Currently the kernel adds the page, allocated for swapin, to the
> swapcache before charging the page. This is fine but now we want a
> per-memcg swapcache stat which is essential for folks who wants to
> transparently migrate from cgroup v1's memsw to cgroup v2's memory and
> swap counters. In addition charging a page before exposing it to other
> parts of the kernel is a step in the right direction.
>
> To correctly maintain the per-memcg swapcache stat, this patch has
> adopted to charge the page before adding it to swapcache. One
> challenge in this option is the failure case of add_to_swap_cache() on
> which we need to undo the mem_cgroup_charge(). Specifically undoing
> mem_cgroup_uncharge_swap() is not simple.
>
> To resolve the issue, this patch introduces transaction like interface
> to charge a page for swapin. The function mem_cgroup_charge_swapin_page()
> initiates the charging of the page and mem_cgroup_finish_swapin_page()
> completes the charging process. So, the kernel starts the charging
> process of the page for swapin with mem_cgroup_charge_swapin_page(),
> adds the page to the swapcache and on success completes the charging
> process with mem_cgroup_finish_swapin_page().

And of course I forgot to update the commit message.

Andrew, please replace the third paragraph with the following para:

To resolve the issue, this patch decouples the charging for swapin pages from
mem_cgroup_charge(). Two new functions are introduced,
mem_cgroup_swapin_charge_page() for just charging the swapin page and
mem_cgroup_swapin_uncharge_swap() for uncharging the swap slot once the
page has been successfully added to the swapcache.
