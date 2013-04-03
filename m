From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC][PATCH 0/7] memcg: make memcg's life cycle the same as
 cgroup
Date: Wed, 3 Apr 2013 14:43:36 -0700
Message-ID: <20130403214336.GF3411@htj.dyndns.org>
References: <515BF233.6070308@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=i7BWHsJed6St8e1lNTiFIdUsNf0Fc6qQQmoKvruTuMk=;
        b=dAplX5M4roYOrNDs0RQQLgiXB20QujbkpWMx17KSYe57voSVB+lt+YtCfkEvDPzRDk
         0Lv8TOHfee8g0wxxOun5TyElYFNZj85gNZ0O+dwce0NfI1kHAOActWOvkTUn6CLbXK/G
         lCFrrwd06OyP0AywpCPdzAPjaebDqYg5wZEovGcTz5zfJKxbIhNUTn7eUeiKS16lh5lP
         Fu10WH2tJVPa/MbSvquTxtQyxZKQ3TwmxFQ625vaY6LYL7n0kyszAFhccQGrDJVlkOA5
         M8nuXq2n1NGMYZgZ8enLO9jWb4htFYciU+AjHBf0q9zxn083f08Cl84+ugH2fXtUp6PS
         lLow==
Content-Disposition: inline
In-Reply-To: <515BF233.6070308-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

On Wed, Apr 03, 2013 at 05:11:15PM +0800, Li Zefan wrote:
> (I'll be off from my office soon, and I won't be responsive in the following
> 3 days.)
> 
> I'm working on converting memcg to use cgroup->id, and then we can kill css_id.
> 
> Now memcg has its own refcnt, so when a cgroup is destroyed, the memcg can
> still be alive. This patchset converts memcg to always use css_get/put, so
> memcg will have the same life cycle as its corresponding cgroup, and then
> it's always safe for memcg to use cgroup->id.
> 
> The historical reason that memcg didn't use css_get in some cases, is that
> cgroup couldn't be removed if there're still css refs. The situation has
> changed so that rmdir a cgroup will succeed regardless css refs, but won't
> be freed until css refs goes down to 0.

Hallelujah.  This one is egregious if you take a step back and what
happened as a whole.  cgroup core had this weird object life-time
management rule where it forces draining of all css refs on cgroup
destruction, which is very unusual and puts unnecessary restrictions
on css object usages in controllers.

As the restriction wasn't too nice, memcg goes ahead and creates its
own object which basically is the same as css but has a different
life-time rule and does refcnting for both objects.  Bah....

So, yeah, let's please get rid of this abomination.  It shouldn't have
existed from the beginning.

Thanks a lot for doing this!

-- 
tejun
