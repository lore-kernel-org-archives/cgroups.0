From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 2/2] cgroup: reset css on destruction
Date: Tue, 1 Mar 2016 11:30:18 -0500
Message-ID: <20160301163018.GE3965@htj.duckdns.org>
References: <69629961aefc48c021b895bb0c8297b56c11a577.1456830735.git.vdavydov@virtuozzo.com>
 <92b11b89791412df49e73597b87912e8f143a3f7.1456830735.git.vdavydov@virtuozzo.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=aMF4QQKC+Sc59i/rnAtq7E56sf0BvWfavGwEdcENX/s=;
        b=gLaNldQIM7IiyXywVfj9Z7xxvNBZEyggAT5oquF9v8QW0RgxsbMo64n5mhZV/0Nbzv
         xTz+5+Evsk1Mw90bKItbTuKDYIZRis9ukg+O+FTTzQYYvPtug7TsneBTmk27mv/hh8UO
         0V/uEFjmN1rNrt/WOMdEkYOd1aNc77bkchLrqEtprxHRN5eHht/yOhgGCIMdP7x6950Y
         znoW+p/H4Cqnc+V9HQ7uZCrVglULVqrpPHGRXhw6SuTDAXdm+z40ANLDRcOpisQsRi60
         om6V7coGHtmglbMivVObu3w59ZC9cDMk3CgyhhrRnD77s4FB4a0r1xDs0C9uu32V1PtB
         7gjQ==
Content-Disposition: inline
In-Reply-To: <92b11b89791412df49e73597b87912e8f143a3f7.1456830735.git.vdavydov@virtuozzo.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vladimir Davydov <vdavydov@virtuozzo.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

On Tue, Mar 01, 2016 at 02:13:13PM +0300, Vladimir Davydov wrote:
> @@ -5138,6 +5138,8 @@ static void kill_css(struct cgroup_subsys_state *css)
>  	 * See seq_css() for details.
>  	 */
>  	css_clear_dir(css, NULL);
> +	if (css->ss->css_reset)
> +		css->ss->css_reset(css);

I think the better spot for this is in offline_css() right before
->css_offline() is called.

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
