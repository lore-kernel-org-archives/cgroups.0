From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH bpf-next] cgroup: support attaching eBPF programs to
 net_prio cgroup
Date: Thu, 25 Jan 2018 07:50:29 -0800
Message-ID: <20180125155029.GG17457@devbig577.frc2.facebook.com>
References: <1516894728-2061-1-git-send-email-laoar.shao@gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=wyvc54W7yPVwtZE05ylNpWLwMF40Faz2jAfjTqbyT08=;
        b=PJ9xf3MtfAkVNG7SqIo1mN7WcbNhAMq+e10uy7jc1UKOCHHoZsL6+ps7V1ghdMbGwg
         1S6oAk+Rz9cfnHLjpbX3qsOo3SKGd5t/wI7xT8VfarMkZ7DzcDy9X1UOZUoqf3rL1y3N
         NsKT9ndub7IvC6qwyGFPcWLy4MBLYTCAjCOH1ryV0/LUaYsjdvnbyAbrswM6rLSEKt7s
         WdhZneUGcbUrIkSR318o9kbJ7bXOaIDhLruAJbX+P4u5DvRRhkBFDiHvoOLhC42RNJNw
         x/n8SjnAMUorybtDdkQlxRMu71k8POf+QKlFWEsIdjhzvRynH1tbZENVcjzlLSoqpvtb
         GZpw==
Content-Disposition: inline
In-Reply-To: <1516894728-2061-1-git-send-email-laoar.shao@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yafang Shao <laoar.shao@gmail.com>
Cc: guro@fb.com, davem@davemloft.net, longman@redhat.com, lizefan@huawei.com, hannes@cmpxchg.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, Jan 25, 2018 at 11:38:48PM +0800, Yafang Shao wrote:
> If net_prio is used, we could also use eBPF programs to attach it,
> because the net_prio cgroup could be got with prioidx in struct
> sock_cgroup_data.
> Hence it should not only be limited to cgroup2.

I really don't wanna do this.  This comes with all sorts of reverse
lookup and naming issues.  In addition, cgroup1 and 2 aren't mutually
exclusive.  If the use case is on cgroup1 and wants to use cgroup bpf
programs, just replicate the cgroup2 hierarchy for bpf.  Hierarchy
replication across different controllers is how most use cgroup1 after
all.  With recent versions of systemd which defaults to using cgroup2
for process management, you get the replication for free too.

Thanks.

-- 
tejun
