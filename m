From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] docs cgroups: add another example size for hugetlb
Date: Thu, 30 May 2019 14:04:04 -0700
Message-ID: <20190530210404.GX374014@devbig004.ftw2.facebook.com>
References: <20190529222425.30879-1-odin@ugedal.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=QvB7om0vcev2wAaZ6mNs20WHEWnppnnUocSSe4PmuQc=;
        b=R+OBAIIDsIp//zF5ukSuUovTfYFEJoCkFYDnb9WiLXH8OEUgBUOh8R1UVMP2YHb3OF
         eReMh3bHTFhHiOFpIbZPL1rHF0/tIz4ay3Qv6E+WxX61iPzm6Sq8L/tCl1fC9591Rcn8
         kqtj2T9JMKOVskaMpfkZ6QK7TIZrXEBSr4ePs+hZSUnoxKdhtgqKNuoB1oHBjubmzhsT
         KaGYvH9sdz6DY7yn5Jssy8UUZ7WJkyXdsclyjAELQYnkmjwVcilDK3603hs/0AuGOMAT
         S3UDgagjoQMIyUs2GB1tFWADaSHLRMNcXQHy0YOcfEcgyb09aUl/4338+95fDdYqk13y
         gFVg==
Content-Disposition: inline
In-Reply-To: <20190529222425.30879-1-odin@ugedal.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Odin Ugedal <odin@ugedal.com>
Cc: Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>

On Thu, May 30, 2019 at 12:24:25AM +0200, Odin Ugedal wrote:
> Add another example to clarify that HugePages smaller than 1MB will
> be displayed using "KB", with an uppercased K (eg. 20KB), and not the
> normal SI prefix kilo (small k).
> 
> Because of a misunderstanding/copy-paste error inside runc
> (see https://github.com/opencontainers/runc/pull/2065), it tried
> accessing the cgroup control file of a 64kB HugePage using
> "hugetlb.64kB._____" instead of the correct "hugetlb.64KB._____".
> 
> Adding a new example will make it clear how sizes smaller than 1MB are
> handled.
> 
> Signed-off-by: Odin Ugedal <odin@ugedal.com>

Applied to cgroup/for-5.2-fixes.

Thanks.

-- 
tejun
