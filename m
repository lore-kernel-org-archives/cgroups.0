From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHv1 2/6] IB/core: Added members to support rdma cgroup
Date: Tue, 5 Jan 2016 16:56:56 -0500
Message-ID: <20160105215656.GI5995@mtj.duckdns.org>
References: <1452020286-9508-1-git-send-email-pandit.parav@gmail.com>
 <1452020286-9508-3-git-send-email-pandit.parav@gmail.com>
Mime-Version: 1.0
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=4P0cE7myxQKamfehlVjQBWW5zjqk7iGcgkFtpBwSqdc=;
        b=cVKKLtBX2HBGjkreTuxNzJ1JF0XZFBF2yCXUml12HAsI96Asi9/qAQgcTBHvZ7OOL+
         2Su1bul0m3ZATPYLxToOPax6JImWCE9ZUPsSE+JgnWY7bwPWdXcJ/G0h2AFBlJmE7l6i
         CQOk7urQAh8N4kXvOQf6iBAAdQSCiwGeUa3eFsW/sgBy+LdVcT0mRBwND8N24ci8ubmT
         aIVI7DtPTShZ4nwY7hzXzkTC081AJyc6d6LNUKKKKpgtmrGo7sS1wZ370ODUIhZ/beSN
         UEdQ5JhbeybJbqHSryMTjy74utiegzpgbqw+J+oeIwhdHAs+fnB4kr8mYuqSef2Ro2lo
         vFeQ==
Content-Disposition: inline
In-Reply-To: <1452020286-9508-3-git-send-email-pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Jan 06, 2016 at 12:28:02AM +0530, Parav Pandit wrote:
> Added function pointer table to store resource pool specific
> operation for each resource type (verb and hw).
> Added list node to link device to rdma cgroup so that it can
> participate in resource accounting and limit configuration.

Is there any point in splitting patches 1 and 2 from 3?

-- 
tejun
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
