From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATH v2] cgroup: add cgroup_favordynmods= command-line option
Date: Mon, 18 Sep 2023 07:47:13 -1000
Message-ID: <ZQiNIWQe7spOwjil@slm.duckdns.org>
References: <20230906005712.66461-1-luizcap@amazon.com>
 <29bdb453-c6e3-a047-1f27-e9656da92301@amazon.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695059236; x=1695664036; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lPhgdY/CmzoobfbrK6uZSQDRjVzzTjVIIZJoiShDRQ8=;
        b=WHBZpebE02E1wErRLGRIM+C4JllVNMWT4idpU3lhC8boizv/+y7d69c/VQYQBmzuY8
         +f7d08xMWcRZqU6rSAZU0wFXD60ePk0fM17Q+8lTdE1U5E51DpcrBtstKc595sHz+Dxt
         4Cge0Eqwp1MOsEpU3OXuUZDY5SOA/RkAT7o46Qp3ZqK1J/mzGBqpFKsoMzaDWeeOjv9/
         Be6gs1MkquHVz9jqY2/cJP2gw1b9kCFfDeOiIOkys0Yb48D66GBTC9F63xfCw13acsyo
         HMbEGK9TZ8Bf9TXOVREVylWgMbLFiaW+SIl+oMfo8hX5A8hW4M0HXibxq9FvxKmESAXA
         pdHQ==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <29bdb453-c6e3-a047-1f27-e9656da92301@amazon.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Luiz Capitulino <luizcap@amazon.com>
Cc: lizefan.x@bytedance.com, hannes@cmpxchg.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, longman@redhat.com, lcapitulino@gmail.com, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>

On Mon, Sep 18, 2023 at 10:01:13AM -0400, Luiz Capitulino wrote:
> 
> 
> On 2023-09-05 20:57, Luiz Capitulino wrote:
> > We have a need of using favordynmods with cgroup v1, which doesn't support
> > changing mount flags during remount. Enabling CONFIG_FAVOR_DYNMODS at
> > build-time is not an option because we want to be able to selectively
> > enable it for certain systems.
> > 
> > This commit addresses this by introducing the cgroup_favordynmods=
> > command-line option. This option works for both cgroup v1 and v2 and
> > also allows for disabling favorynmods when the kernel built with
> > CONFIG_FAVOR_DYNMODS=y.
> > 
> > Signed-off-by: Luiz Capitulino <luizcap@amazon.com>
> 
> Ping?

Michal raised some valid concerns. I don't really mind that it's not great
on the edges tho. Michal, what do you think?

Thanks.

-- 
tejun
