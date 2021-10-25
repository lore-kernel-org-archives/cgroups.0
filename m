From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 3/3] cgroup: no need for cgroup_mutex for /proc/cgroups
Date: Mon, 25 Oct 2021 07:27:02 -1000
Message-ID: <YXbo5sKj0wgPTaMp@slm.duckdns.org>
References: <20211025061916.3853623-1-shakeelb@google.com>
 <20211025061916.3853623-3-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=aCZMd4lnZUOWP3HuMJZrRTDzuvD7CVVCcTZfYmmmVYQ=;
        b=jB5xsxczN9t/FAMcQj8CtRTnmhHtZXcl5SVodMk6K4L0F+P8ivxWvi/7AOYRNNw2c5
         KgPQbGuOcYNZKx1m7ZpDeJVGp9IyLAFuM1H1CS7mMqU+ISDG24Qh2p6Eob0J9QViMiM4
         u9ctfqMNOaSDV55qSmdjPIGyT64q4bwDb4sA/bO1X/PUCNARks1jSVYH+BdU1XvlLLjF
         g/hIj+1qJQAWhQ72vovkRU8MFKxf0eTuqGdobXFdu51L2ZK1vyfZA/GQti8M8RJwq6DV
         9TzFRGA8MWJ0er52eshkuUVcHxxcwY7IHlTAZOqrkJrskNDDBpzTj2Cr2VGyPEXE9fwZ
         37Tg==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20211025061916.3853623-3-shakeelb@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb@google.com>
Cc: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Sun, Oct 24, 2021 at 11:19:16PM -0700, Shakeel Butt wrote:
> On the real systems, the cgroups hierarchies are setup early and just
> once by the node controller, so, other than number of cgroups, all
> information in /proc/cgroups remain same for the system uptime. Let's
> remove the cgroup_mutex usage on reading /proc/cgroups. There is a
> chance of inconsistent number of cgroups for co-mounted cgroups while
> printing the information from /proc/cgroups but that is not a big
> issue. In addition /proc/cgroups is a v1 specific interface, so the
> dependency on it should reduce over time.
> 
> The main motivation for removing the cgroup_mutex from /proc/cgroups is
> to reduce the avenues of its contention. On our fleet, we have observed
> buggy application hammering on /proc/cgroups and drastically slowing
> down the node controller on the system which have many negative
> consequences on other workloads running on the system.
> 
> Signed-off-by: Shakeel Butt <shakeelb@google.com>

Applied 1-3 to cgroup/for-5.16.

Thanks.

-- 
tejun
