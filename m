From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cpuset: Make cpuset hotplug synchronous
Date: Wed, 12 Feb 2020 16:18:32 -0500
Message-ID: <20200212211832.GC80993@mtj.thefacebook.com>
References: <1579878449-10164-1-git-send-email-prsood@codeaurora.org>
 <ee889f30-cb81-e0a8-6068-715ca3399fdd@codeaurora.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=31Bj/38A/miaqKjQ58NWeMSoyVnEc1IA1pOEeW3/4nw=;
        b=se4ZxKttnmJxS0lSBYkjbIQ+INqZmThMGsXTtfEn4e2uCBdd7rJ/EyTMKVuXO1FSGg
         0CNxDUOhb1WNHlOIFR9LPNUVRZGiR+THOt7o3DpRgvM9AqFvLVp7XIkha5fMN/NPgMJN
         6VNJkiCSz6Wc/8awOwnb9zcux4XTt89eUmyxtt6yZE8Hy9oWjn5FchInQTyVUhP8I4ho
         g2V2OC2kOR7VvZCH8VF1oD4m5Twj5iNpjNMx/1/IGBrRu6nMINVbbCNvPRRoAdtQy46w
         xqGASdvr2OaiPE4NOmdwBDQ4Gd8UCS3JS3t5x1l5FE9OhWX6hZ7gUOG5GAvGWaZSIV9F
         iMcA==
Content-Disposition: inline
In-Reply-To: <ee889f30-cb81-e0a8-6068-715ca3399fdd-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Prateek Sood <prsood-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Cc: peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sat, Feb 01, 2020 at 08:33:34AM +0530, Prateek Sood wrote:
> Hi Tejun & Peter,
> 
> Could you please share your feedback on this patch for making
> 
> cpuset_hotplug_workfn synchronous.

Hey, IIRC, we went back forth with this several times. Unless there's
a pressing reason to change, I'd rather leave it alone.

Thanks.

-- 
tejun
