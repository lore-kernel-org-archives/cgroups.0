From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH resend 1/3] vmpressure: change vmpressure::sr_lock to
 spinlock
Date: Tue, 23 Jul 2013 12:17:24 -0400
Message-ID: <20130723161724.GA21100@mtj.dyndns.org>
References: <1374252671-11939-1-git-send-email-mhocko@suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=nxXbOeCYv2lD+hHh5c/OuXgtbxHihzh1xu63C9t3khI=;
        b=NA5zMIU8tq/vI/pG0eM0njBJiN7cpshgkBZRcMBDJctLiXP5pQ/t1AwZoJUxj/0Ej8
         jagUN36gfTQtVBpBQ7CSvyhN0NkQtx7DlFUmt3INw9weZyBdyQ74YCHlqDVPxIxGK0Fs
         widiboBiN+BM1S2bRq9csO7XrJtki+yfC/5dR4Dxsscp60lhqjuavF1wHh+v/DfplK9O
         YsMwqwcPkeu5Gl7G9USdBSWhpaqzjzWLzbzmikNEL7rq7RXnKPYx8mdMsIh+nGPAO6UK
         V6yRXQE4ZNgTa4d92lCyuAD80DXKA7kBzeMLTKmTiE6nUt4uqcotgSNaSGbH4ZYtNnzS
         C10A==
Content-Disposition: inline
In-Reply-To: <1374252671-11939-1-git-send-email-mhocko@suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, Anton Vorontsov <anton.vorontsov@linaro.org>, Johannes Weiner <hannes@cmpxchg.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, Li Zefan <lizefan@huawei.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

Hello, Michal.

Sorry about the delay.  Was on the road.

On Fri, Jul 19, 2013 at 06:51:09PM +0200, Michal Hocko wrote:
> There is nothing that can sleep inside critical sections protected by
> this lock and those sections are really small so there doesn't make much
> sense to use mutex for them. Change the log to a spinlock
> 
> Brought-up-by: Tejun Heo <tj@kernel.org>
> Signed-off-by: Michal Hocko <mhocko@suse.cz>

Reviewed-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
