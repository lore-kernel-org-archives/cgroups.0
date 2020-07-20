From: "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
Subject: Re: [PATCH v16 05/22] mm/thp: move lru_add_page_tail func to
 huge_memory.c
Date: Mon, 20 Jul 2020 11:37:51 +0300
Message-ID: <20200720083751.7q4wgmrsefknzwyd@box>
References: <1594429136-20002-1-git-send-email-alex.shi@linux.alibaba.com>
 <1594429136-20002-6-git-send-email-alex.shi@linux.alibaba.com>
 <924c187c-d4cb-4458-9a71-63f79e0a66c8@linux.alibaba.com>
 <20200716131706.h6c5nob4somfmegp@box>
 <045c70c7-e4e4-c1d1-b066-c359ef9f15a5@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=74/+EzKUAAKlAxACD2N9LwyXc8GIiGB7bIu4cn5OH/s=;
        b=vQVQN9m3LFq9Ac9pxVX05L3jLmD+2U9Pg1NxkoR0om6MN0CgbAArh2CJ12CXyxrFL+
         3IiUGT7KD5izRqhVEEWIKJ1KhzHpmeUgBTXRK4tmYXrW5WPJUyvjKhX8m0dnyhs09+oR
         t1dtcXDwSBOkQvQ/TfJJGBUo92n6DLuwqrJ601PkTy6Od1gF51Bi7eX6vu3TsT7C7PVn
         c/DB1ZpauA4MiBkr0bPc6oMt7vhuCfZqK1rcCXl/s6VT7E7q1kuWtLu+R2y01txevzpH
         8yDU7lAbqd60QD5jlYltL3AAJxoUEeBpsKjJhlFwY2RtgUXj085jYnNnDTfB78cdrtWC
         vmJQ==
Content-Disposition: inline
In-Reply-To: <045c70c7-e4e4-c1d1-b066-c359ef9f15a5-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org, richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

On Fri, Jul 17, 2020 at 01:13:21PM +0800, Alex Shi wrote:
> 
> 
> 在 2020/7/16 下午9:17, Kirill A. Shutemov 写道:
> > On Thu, Jul 16, 2020 at 04:59:48PM +0800, Alex Shi wrote:
> >> Hi Kirill & Matthew,
> >>
> >> Is there any concern from for the THP involved patches?
> > 
> > It is mechanical move. I don't see a problem.
> > 
> 
> Many thanks! Kirill,
> 
> Do you mind to give a reviewed-by?

Reviewed-by: Kirill A. Shutemov <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

-- 
 Kirill A. Shutemov
