From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v3 0/8] cgroup: Assign subsystem IDs during compile time
Date: Tue, 11 Sep 2012 14:11:51 -0700
Message-ID: <20120911211151.GC7677@google.com>
References: <1347380774-9546-1-git-send-email-wagi@monom.org>
Mime-Version: 1.0
Return-path: <netdev-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=Msy8xCh9b8ISBSVr3P7JgdZJg3uBuXfX3rJ2Kafy3gw=;
        b=k5HLiBIwUZ7s3XiVaCF4QO2G2MRyt+2URL6ubtqxzTCFjWcjz7jbqoLUTDBJzgWbv4
         GFmw8gsNAZfm3iXHdrK1jpiuMSb7W5FHmPvBdCkTkBIc8CvHvKRs5d371iFsw2f0aH+E
         DbZjMyC6NckA5VnHD3PY+vCEbXVAZ0nTZ3I+9EUveZop3oeYAHoJswX6rUZG5nSdtKoQ
         hIx4exGUqm1lqpdhL5YdVcHcP1RMeDo/trlDKICRy72ep7ZfN7wdLFuVHQMLelq7CxUJ
         F85ExgQTdYSr96p3I83vbzXNF8WX1p2plNQfIrnd/5fcRqyNVsOOlMVsvV1vNdr7UxOP
         yz7g==
Content-Disposition: inline
In-Reply-To: <1347380774-9546-1-git-send-email-wagi@monom.org>
Sender: netdev-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Daniel Wagner <wagi@monom.org>
Cc: netdev@vger.kernel.org, cgroups@vger.kernel.org, Daniel Wagner <daniel.wagner@bmw-carit.de>, "David S. Miller" <davem@davemloft.net>, Andrew Morton <akpm@linux-foundation.org>, Eric Dumazet <edumazet@google.com>, Gao feng <gaofeng@cn.fujitsu.com>, Glauber Costa <glommer@parallels.com>, Jamal Hadi Salim <jhs@mojatatu.com>, John Fastabend <john.r.fastabend@intel.com>, Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Li Zefan <lizefan@huawei.com>, Neil Horman <nhorman@tuxdriver.com>

Hello,

On Tue, Sep 11, 2012 at 06:26:06PM +0200, Daniel Wagner wrote:
> From: Daniel Wagner <daniel.wagner@bmw-carit.de>
> 
> Hi,
> 
> In this version I tried to concentrate on the main topic of this
> series, so I removed some of the things which were not really needed
> and I have to admit the result looks much better. So I hope that will
> simplify the review for you.

Other than the few nits I like the whole series and, given that all
the changes are entangled with cgroup core, I would like to route it
through cgroup/for-3.7 if nobody objects.  Daniel, can you please
rebase on top of the following branch when sending out updated
version?

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-3.7

Li, can you please review these?

Thanks.

-- 
tejun
