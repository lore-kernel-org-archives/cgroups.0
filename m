From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v5] Soft limit rework
Date: Fri, 21 Jun 2013 09:34:32 -0700
Message-ID: <20130621163432.GB31218@htj.dyndns.org>
References: <1371557387-22434-1-git-send-email-mhocko@suse.cz>
 <20130620111206.GA14809@suse.de>
 <20130621140627.GI12424@dhcp22.suse.cz>
 <20130621140938.GJ12424@dhcp22.suse.cz>
 <20130621150430.GL12424@dhcp22.suse.cz>
 <20130621150906.GM12424@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=ymmT/kx0t1CT7F9o7dapGxZcbn/xENVDZKG27M0j/F0=;
        b=xrTlZgCbCCSs9K7YU6GVMUc7F4GiXpjRCw2TUt/E886GSSVhjNXcedx1XQdNJ/tVPa
         4hIvjvJDbHW9XMrV9E728/upc2DVy7M0NvrZUlw8YnkT5+Nx3XHwg4++FkmH6oNWGiJU
         dbCh4aJ66F2df7BiB3fkBJ56ukPNtJnHbTqKl0BvSznEY4V1hDqg4Xal3MDrw77gW8ve
         kqvyKsjAoKVgGhHvvCbJyNf8kuQ7XxR96Fa8T1k94Zu5s0499WGYuoT6Z3DXVDyzl0cU
         iIRY3YeIa/6NDZtkDlz+DCLklv4yFwTM/lfVVEl2De5H/XmyfXHQkw4giKirnnntctFj
         Sbpw==
Content-Disposition: inline
In-Reply-To: <20130621150906.GM12424@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.cz>
Cc: Mel Gorman <mgorman@suse.de>, Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Ying Han <yinghan@google.com>, Hugh Dickins <hughd@google.com>, Michel Lespinasse <walken@google.com>, Greg Thelen <gthelen@google.com>, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, Balbir Singh <bsingharora@gmail.com>, Glauber Costa <glommer@gmail.com>

On Fri, Jun 21, 2013 at 05:09:06PM +0200, Michal Hocko wrote:
> And I am total idiot. The machine was not booted with mem=1G so the
> figures are completely useless.
> 
> It is soooo Friday. I will start everything again on Monday with a clean
> head.
> 
> Sorry about all the noise.

Oh, don't be.  It was the most fun thread of the whole week.  Enjoy
the weekend. :)

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
