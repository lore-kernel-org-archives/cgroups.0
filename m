From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH resend 2/3] vmpressure: do not check for pending work to
 prevent from new work
Date: Tue, 23 Jul 2013 12:17:50 -0400
Message-ID: <20130723161750.GB21100@mtj.dyndns.org>
References: <1374252671-11939-1-git-send-email-mhocko@suse.cz>
 <1374252671-11939-2-git-send-email-mhocko@suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=njld4iyZ8HdHnYtPw6hRgUJ7czLwJGEzty9VaiHLKjg=;
        b=dt3q5JzW6NoNE1dXhW8GgTNyqbIUVx/nyqIssOFpQpFTz0pgsVTZ+IxYpSFm0pHYvT
         K4Uo3mAZ17wousilF3EVjbmU7E20ADq1x63Kg3CcwijFoxFmXOfmye1GfljaDC/JmlfN
         ZGFF5B+BeL0+7gGve1u8jhVSur+yrc9MLfIqUHyUZzjg9a460Um8ww5vde2u6Xkr2vFR
         kc2GwinkhObMqoCjefqQIpaWlsGlJQjoMedokgGjkM+SbwOBMG7PbzTZNyrDaCoipDa7
         oFmgRhGR1SUWvrdFNtmztNxf07fSPjPNWcqluHt4upn6x/lF/xP5F99r6qpJWYoxPeTD
         IBBw==
Content-Disposition: inline
In-Reply-To: <1374252671-11939-2-git-send-email-mhocko@suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, Anton Vorontsov <anton.vorontsov@linaro.org>, Johannes Weiner <hannes@cmpxchg.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, Li Zefan <lizefan@huawei.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Fri, Jul 19, 2013 at 06:51:10PM +0200, Michal Hocko wrote:
> because it is racy and it doesn't give us much anyway as schedule_work
> handles this case already.
> 
> Brought-up-by: Tejun Heo <tj@kernel.org>
> Signed-off-by: Michal Hocko <mhocko@suse.cz>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
