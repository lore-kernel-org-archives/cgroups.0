From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 3/7] cgroup: restructure the failure path in
 cgroup_write_event_control()
Date: Wed, 31 Jul 2013 06:44:48 -0400
Message-ID: <20130731104448.GH2810@htj.dyndns.org>
References: <51F8C7C5.9040608@huawei.com>
 <51F8C802.7070404@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=+DwG/ntxUxWt6xFcyB0QdQeGO2p6SXr1WFVel9FOCEs=;
        b=SOXbmiMazM8zULgMlVVHxhrlB22KJZpG3bmhV1KO0WfzmF565YbF5c1f8Lu6ASTvug
         YE40ap8p8sJ8afmju6thdA+GHtsa3dePuSugR3xg2G/AK0D8UIdHeVKyGWfgpFOy8c0U
         4G8pkXbup5AfUD6trdGyw37g3BVOB9lul8L6zmdGSmLxNzmseo33pMBNczgctF4dAO5K
         KsqMQ+EcYP4soZUkBVeYzsGah2kW83E7OuJzyR1QAT7F8DQB1qS3HnTswfx8xvZky9CZ
         bLdGhGPuetL13kDsr0dM0dN5TLOTFbBQnA4t3yotMscVPwIiHbu63t7GKVh37bxoR1c/
         g5PQ==
Content-Disposition: inline
In-Reply-To: <51F8C802.7070404-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Wed, Jul 31, 2013 at 04:17:06PM +0800, Li Zefan wrote:
> It uses a single label and checks the validity of each pointer. This
> is err-prone, and actually we once had a bug because one of the check
> was insufficient.
> 
> Use multi lables as we do in other places.
> 
> Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Hmm... I usually prefer mix of the two approaches as both extremes
tend to be pretty ugly when things get complex.  I don't mind the
conversion but can you please drop the no longer unnecessary NULL
assignments on variable definitions?

Thanks.

-- 
tejun
