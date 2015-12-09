From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: occasional kernel hang on shutdown - kernel/cgroup_pids.c
Date: Wed, 9 Dec 2015 11:09:07 -0500
Message-ID: <20151209160907.GL30240@mtj.duckdns.org>
References: <20151207235352.GW15569@logic.at>
 <20151209132253.GB30912@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=Iaj7GKq+0K6c0Y4OvWNR2AmS+sqhQh++tYJnH01MSEk=;
        b=Y56DW8HLuBPdyo80syRlxshIHxC+XkQoB8KU39cPcD6EYUbiU3MvhnU3e1m7EpdRKd
         UE70izUn73ED+JLQl4o6cWo3Q0r0gLmMURfwXdHmkcHbZut1tIDgHPNJOOCOqdpY21PR
         78/6d32tA6n8PFUqZxovbg74oc0mx0eXYZZbjUbQ7vj4TftndpoIVt8hjoe94a/kMPPQ
         3e3oSz5TMfupGurNsv+W3GMvnO6Olh60+Bl/V08aApnK6pDds9oq9zaz6awPhFWC1t/J
         aD4g+m10mQcwACXyxj2hw7MlmUpiJ0xgDAGyAHDo5AsLxSZ92sVjTeLB4RwltZNkbmPv
         5klQ==
Content-Disposition: inline
In-Reply-To: <20151209132253.GB30912-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Norbert Preining <preining-DX+603jRYB8@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups mailinglist <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Wed, Dec 09, 2015 at 02:22:53PM +0100, Michal Hocko wrote:
> [CCing Tejun]
> 
> Seems to be the same issue as reported here?
> http://lkml.kernel.org/r/20151208145851.GJ9837@bark

Patches just got merged into mainline.  Please let me know if the
current git master doesn't fix the issue.

Thanks.

-- 
tejun
