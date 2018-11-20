From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH cgroup/for-4.21 1/2] cpuset: Minor cgroup2 interface
 updates
Date: Tue, 20 Nov 2018 13:46:24 +0100
Message-ID: <20181120124624.GL2131@hirez.programming.kicks-ass.net>
References: <20181113201339.GN2509588@devbig004.ftw2.facebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=Hx+N0qqyp8Kutna+wQulsJnrAVNatTI43rCTFTdq0qk=; b=f3HNuLdmTaWL6U6rNKK0XscSJ
        ZBfbc3GRz8rgcfXZeSe0LlAINtRcvwb7puUf7gCuRUfLDJn3U9vyhBNt0XEbdSMnsoLB1RFVSMlKB
        rRFSui1FQYkSrdrklS+gqdxKAk8cfmF+D+/Wxscox/Z1RHHuXiqaNFE/SIGsU0um6eJWOarofYWeJ
        06lXtzh0kmYd4CXEkyqJT08b9mFmp4zwgpAK/pxxJOydRwQiCNqBd7KBhTTjSzMWHKV6zPGfTKOld
        k3NGw/D71OUlBpwmZvYxBm/+z4J7hNpjchRwhwjk7oeQgrQ8uEDJbTb3RbPGzsrDbm9ztwT5RtxPl
      
Content-Disposition: inline
In-Reply-To: <20181113201339.GN2509588@devbig004.ftw2.facebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Waiman Long <longman@redhat.com>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, Nov 13, 2018 at 12:13:39PM -0800, Tejun Heo wrote:
> From b1e3aeb11c5e86ee0988a038c4e7682d6beaa977 Mon Sep 17 00:00:00 2001
> From: Tejun Heo <tj@kernel.org>
> Date: Tue, 13 Nov 2018 12:03:33 -0800
> 
> * Rename the partition file from "cpuset.sched.partition" to
>   "cpuset.cpus.partition".
> 
> * When writing to the partition file, drop "0" and "1" and only accept
>   "member" and "root".

Why though? The Changelog doesn't give rationale for the actual changes.

And I'm not sure I agree with either one of them.

The partition is a scheduling feature; and I like 0/1 much better to
type, so why not allow that?

