From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/2 cgroup/for-6.1] cgroup: Improve cftype add/rm error
 handling
Date: Tue, 6 Sep 2022 09:39:49 -1000
Message-ID: <YxeiBUwloEJu0lX9@slm.duckdns.org>
References: <YxUUISLVLEIRBwEY@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date;
        bh=nlsO3qydHURiPESopIov6MAWpclh/6/lYNHj0fbMC4I=;
        b=F95JAOTLsk80DmB2KeBQgUrMKsGMMDbmiSIJ2kqa34nWGZYTBl8qput1L3OvMfrpT/
         7wYPdbsd+Fi40BVF+9zcjae67Ef+gtoJ7K6An5VoNJVwtUs/3vKY7r9si0wn6Selg86T
         DBRnMRgfYKDRb/L0N3PFfwW7IpTNqxBruOrLKYXsw2n2fzKSff6w6vJ38x+Sn1Bq3cob
         GCBx+lymS4kLxe5VAN5g/DsGnOUu6r31+icQfgTovFcAXY0CPRiJqH5TaKIjKZQFi9l4
         chRU/9Dw9ZWxxkhxSrs/MNuKS8DxxTL3JS7U3VFBaiihZtzSKNCh9C/0AM8DkLmfOYZx
         vL0Q==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <YxUUISLVLEIRBwEY-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Sun, Sep 04, 2022 at 11:09:53AM -1000, Tejun Heo wrote:
> Let's track whether a cftype is currently added or not using a new flag
> __CFTYPE_ADDED so that duplicate operations can be failed safely and
> consistently allow using empty cftypes.

Applying 1-2 to cgroup/for-6.1.

Thanks.

-- 
tejun
