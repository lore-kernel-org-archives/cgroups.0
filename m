From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 3/3] cgroup: set visible flag only after we've mounted
 the default root
Date: Tue, 3 Jun 2014 09:02:20 -0400
Message-ID: <20140603130220.GC26210@htj.dyndns.org>
References: <538D4956.5050205@huawei.com>
 <538D49A7.2010403@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=iLKNjRzNOKmkL40Wwmf7qUMWD+RW28q5ujOG/4yzNIM=;
        b=OjCFSRb2jr7BUrb4UGJOoje5MRUAblHbML4iOydcy2/4Gx3jse9owbAJtwlR4JvL2O
         FuLDRZqralYnmjjKqXqdtbxdWsp/RKK87ro8YgyroAmCZtjATkUASorkFsHOGdP0TxHS
         RFmr4rdJYK9ADz78XidEhusEE8JfUvKGDmZiw96KXzk0rknDYkUGUG9MlhMme1dl74hz
         bE76sno2DNpGcK6/A6PX7KTZxVxSoEsP8rj1BWcRbP4ZPsDoAjmQOSi21dc2Hkka94cJ
         DJTLUimPVgZyJ6Wvy1nZYZ6kzMAfbhjOCtWyk/CYbIplvRKyp22wjaJys8ReF0wpDuCl
         c/aw==
Content-Disposition: inline
In-Reply-To: <538D49A7.2010403-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Tue, Jun 03, 2014 at 12:05:59PM +0800, Li Zefan wrote:
> This fixes the failure path, so we won't set the visible flag though
> the mount is failed.

Same rationale.  If the userland knows about it, there's no point in
hiding it.

Thanks.

-- 
tejun
