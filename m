From: Wei Yang <richard.weiyang@gmail.com>
Subject: Re: [PATCH] cgroup: return early if it is already on preloaded list
Date: Tue, 14 Dec 2021 00:36:04 +0000
Message-ID: <20211214003604.mvmqg4i4zj2t4toq@master>
References: <20211211161729.10581-1-richard.weiyang@gmail.com>
 <YbeekNeegXoP6F93@slm.duckdns.org>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=k6D7bydG+h+WxA2aq/kFkeCmdgG2RGXOzUIul9d5/ow=;
        b=JRH8+qRZGG1TG8wzZBp+RioBZjOczlUTjlWMxmj/jw3xIISIHAfwyQt4CBGMQ3NVod
         1rwrPMe61hRHJb7rFMJalTnGJ5snPSd9HGjCC2UcHpD7TiM5Y6ns3fIzLK1IdIibKlsW
         cU2+eYUfJwOQIg0D3Dc7+8CN8luvAG6JDYS1/dmlSfdx4DthfUW0rHSoQLC0w5ZyBsAa
         8AnLOt1NMUlrB54aCCcD8sBi+f2NF9qQqEWBqw2iz3K1SZeZ6AxqM7KKrD/vLzrmpa7E
         WcY0iW4KsFKMYsO9DmogO3CaXaL9JNU0Jf9xFJ3Jr0ZRaTMbpiLNWpNwGxRQ1Hxoi5/s
         zvGQ==
Content-Disposition: inline
In-Reply-To: <YbeekNeegXoP6F93@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>, lizefan.x@bytedance.com, hannes@cmpxchg.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, Dec 13, 2021 at 09:27:12AM -1000, Tejun Heo wrote:
>On Sat, Dec 11, 2021 at 04:17:29PM +0000, Wei Yang wrote:
>> If it is already on preloaded list, this means we have already setup
>> this cset properly for migration.
>> 
>> Let's skip this cset on this condition.
>
>The patch looks fine but I think description can be improved. Can you just
>say that it's just relocating the root cgrp lookup which isn't used anyway
>when the cset is already on the preloaded list?
>

Sure, let me try to rephrase it :-)

>Thanks.
>
>-- 
>tejun

-- 
Wei Yang
Help you, Help me
