From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] cgroup: minor tweak for logic to get cgroup css
Date: Mon, 8 Jul 2019 09:42:43 -0700
Message-ID: <20190708164243.GE657710@devbig004.ftw2.facebook.com>
References: <20190703020749.22988-1-rocking@whu.edu.cn>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=8IxAaS8HkYeCdm6ofdJNfkVr0RYEAJ+U8cg6TKAE1aA=;
        b=L4VgEUxFKymN8SdwCiz5jn/rBEPjrGbx7eFnC/6wSUv7PRduz3U9K5Wb58pE9nCwOh
         K4B+yYRyrknRJhYhK5GxOAr8okc1478Hpn7cwz/VKt0SCzvrBwHR/NOc9+F67juzgoUl
         TlucAUvTpmHDN6YI/nfX0Cv+I3FnSvxeTZbthwIBDS/D5/643uM+t1caAPoJBE3QKINO
         hkjzqay4+jr7+ZiC4mBgaYshjyViUjma8mTmO9MpWs5vwFYwofGWzCwYgk9D7k/ajgk/
         0RpyJHJRof2GfzuXUrUDsf76MOC/CVeHbyq6lFHXgsRZhHhALQFMfMuY+g/Evqa19ZPf
         upmA==
Content-Disposition: inline
In-Reply-To: <20190703020749.22988-1-rocking@whu.edu.cn>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peng Wang <rocking@whu.edu.cn>
Cc: lizefan@huawei.com, hannes@cmpxchg.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, Jul 03, 2019 at 10:07:49AM +0800, Peng Wang wrote:
> We could only handle the case that css exists
> and css_try_get_online() fails.

As css_tryget_online() can't handle NULL input, this is a bug fix.
Can you please clarify that in the description?

Thanks.

-- 
tejun
