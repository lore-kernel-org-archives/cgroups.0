From: Wei Yang <richard.weiyang@gmail.com>
Subject: Re: [Patch v2] cgroup: pretty format /proc/cgroups
Date: Wed, 17 Nov 2021 00:11:22 +0000
Message-ID: <20211117001122.az2wy3342yd7gkym@master>
References: <20211115011253.20778-1-richard.weiyang@gmail.com>
 <20211116180013.GA8884@blackbody.suse.cz>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=GlqmPq2VIk6eD8ey4VGJbqZUsRwxAJjaJSQyRKeBmc0=;
        b=gW7tY/rX+1sOa7ZeXu+Q32hSrCZTG9t3phjJUZxIzIzZpDUGPWDXsOJat6Xkj+cJQq
         Vy39DaWJm6fxLU7sNCjrBsHK63TyMcoG0HaSHUjV57sfDprKbmUI9fvYG77L/ectftAG
         iaTgu88O5l1wPgtL0vUdmUzU6a5Qnclso/L0pHltw4Tmy0bNRUhlTpEQgTEsRr1aycGE
         IhkVd+ne7ml6pAfWF+GeWUwFQPH2XxpTMIOLdSWfjqroGUwufi7G5a0NNokXHIPljObS
         ae44pjDPEZKG4KZL8VzKunquzq1x/kWwkuMNAYU2gnVRdYdEG/tJwf4FUNrfcMq/Ebur
         SCnA==
Content-Disposition: inline
In-Reply-To: <20211116180013.GA8884@blackbody.suse.cz>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Koutn? <mkoutny@suse.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, tj@kernel.org, lizefan.x@bytedance.com, hannes@cmpxchg.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, Nov 16, 2021 at 07:00:17PM +0100, Michal Koutn? wrote:
>Hello.
>
>On Mon, Nov 15, 2021 at 01:12:53AM +0000, Wei Yang <richard.weiyang@gmail.com> wrote:
>> Let's align the title and value. After this patch, it looks like this.
>
>For machines this change may come as a surprise (so better not change
>it).
>
>For humans (for instance column from util-linux)
>
>$ column -t /proc/cgroups
>#subsys_name  hierarchy  num_cgroups  enabled
>cpuset        11         2            1
>cpu           4          9            1
>cpuacct       4          9            1
>...
>

This is helpful, thanks.

>Michal

-- 
Wei Yang
Help you, Help me
