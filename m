From: David Rientjes <rientjes@google.com>
Subject: =?UTF-8?Q?Re=3A_=E7=AD=94=E5=A4=8D=3A_=E7=AD=94=E5=A4=8D=3A_=5BPATCH=5D_mm=2Fmemcontrol=2Ec=3A_speed_up_to_force_empty_a_memory_cgroup?=
Date: Mon, 19 Mar 2018 10:51:57 -0700 (PDT)
Message-ID: <alpine.DEB.2.20.1803191044310.177918@chino.kir.corp.google.com>
References: <1521448170-19482-1-git-send-email-lirongqing@baidu.com> <20180319085355.GQ23100@dhcp22.suse.cz> <2AD939572F25A448A3AE3CAEA61328C23745764B@BC-MAIL-M28.internal.baidu.com> <20180319103756.GV23100@dhcp22.suse.cz>
 <2AD939572F25A448A3AE3CAEA61328C2374589DC@BC-MAIL-M28.internal.baidu.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=00hVlNXFMIiuvNZxzSHHf9n4hfJDmKRqabqtUXhAKcQ=;
        b=CQY7u07coNzYrPcm0ylwcJhn/fxIlSuFeMMpaxiyVUBkw9D8+xFbgLqamTjfpvL8hD
         qnbd9wmMOOA4vyZRBQDUHdSbBsZQze7n/BFIpxnXwDlhvwa2UjrtmyErsmNB3XUmv4b/
         vHUpSzaksf1C/pwg4f5X+Szt2RXPlq/Ga4yg9HmE6oogBdJXEQiHKIsAW6ywOZql/+7Z
         AN6jzrpGe/nD7VLzcnRBdDw0ZeFJYYlikjMLZmJdNjwetJeAd2zU+QPRWdkZsoi03xgt
         kIgxC+8sOlpRPYIBNpC77joGPhXM/Q7J1fNC7EIOHgVxyvEMjF3qAEixgn6gKGAWkBGV
         iuwg==
In-Reply-To: <2AD939572F25A448A3AE3CAEA61328C2374589DC@BC-MAIL-M28.internal.baidu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Li,Rongqing" <lirongqing@baidu.com>
Cc: Michal Hocko <mhocko@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "hannes@cmpxchg.org" <hannes@cmpxchg.org>, Andrey Ryabinin <aryabinin@virtuozzo.com>

On Mon, 19 Mar 2018, Li,Rongqing wrote:

> > > Although SWAP_CLUSTER_MAX is used at the lower level, but the call
> > > stack of try_to_free_mem_cgroup_pages is too long, increase the
> > > nr_to_reclaim can reduce times of calling
> > > function[do_try_to_free_pages, shrink_zones, hrink_node ]
> > >
> > > mem_cgroup_resize_limit
> > > --->try_to_free_mem_cgroup_pages:  .nr_to_reclaim = max(1024,
> > > --->SWAP_CLUSTER_MAX),
> > >    ---> do_try_to_free_pages
> > >      ---> shrink_zones
> > >       --->shrink_node
> > >        ---> shrink_node_memcg
> > >          ---> shrink_list          <-------loop will happen in this place
> > [times=1024/32]
> > >            ---> shrink_page_list
> > 
> > Can you actually measure this to be the culprit. Because we should rethink
> > our call path if it is too complicated/deep to perform well.
> > Adding arbitrary batch sizes doesn't sound like a good way to go to me.
> 
> Ok, I will try
> 

Looping in mem_cgroup_resize_limit(), which takes memcg_limit_mutex on 
every iteration which contends with lowering limits in other cgroups (on 
our systems, thousands), calling try_to_free_mem_cgroup_pages() with less 
than SWAP_CLUSTER_MAX is lame.  It would probably be best to limit the 
nr_pages to the amount that needs to be reclaimed, though, rather than 
over reclaiming.

If you wanted to be invasive, you could change page_counter_limit() to 
return the count - limit, fix up the callers that look for -EBUSY, and 
then use max(val, SWAP_CLUSTER_MAX) as your nr_pages.
