From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 08/15] blkcg: associate a blkg for pages being evicted by
 swap
Date: Fri, 31 Aug 2018 16:47:59 -0700
Message-ID: <20180831234759.GF1488037@devbig004.ftw2.facebook.com>
References: <20180831015356.69796-1-dennisszhou@gmail.com>
 <20180831015356.69796-9-dennisszhou@gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=LKoqYV3fRAHxp+shYU2I064FBWusEefvf3+MemRkTLo=;
        b=uwsT6ulzy/AxpwfEkm6zmLFkc04MMmE8J2BjtM6SyBh1Gc/L/k/g+nh+avqiELhYgE
         jkklSS7IfDKeu67nbH26+79vauYy1F4G59/qRD5LqFZb5UikbhNooOad7K6xVr/XXMfa
         Cpi6mdBmhfk4G+GGY09nLZJLD8qLJru98GaXZw7lQ4tURfg+5846vPrhdiGLdx9rR0UF
         wZl73S5L8lOehKCQt1Of+PYWt8uzlKtovZU+FgtDwjXGqK6g4G6ckdMahbA3BQuus+H3
         hX8f/S1E9eApT479t76dcBdoKWPmPTEiFke0ZVIYy37JNG4v/x23cTr7cXmmj1MnuG2P
         JRAA==
Content-Disposition: inline
In-Reply-To: <20180831015356.69796-9-dennisszhou@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dennis Zhou <dennisszhou@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>, Josef Bacik <josef@toxicpanda.com>, kernel-team@fb.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, Aug 30, 2018 at 09:53:49PM -0400, Dennis Zhou wrote:
> From: "Dennis Zhou (Facebook)" <dennisszhou@gmail.com>
> 
> A prior patch in this series added blkg association to bios issued by
> cgroups. There are two other paths that we want to attribute work back
> to the appropriate cgroup: swap and writeback. Here we modify the way
> swap tags bios to include the blkg. Writeback will be tackle in the next
> patch.
> 
> Signed-off-by: Dennis Zhou <dennisszhou@gmail.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
