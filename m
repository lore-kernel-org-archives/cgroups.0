From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/2] cgroup, cpuset: replace cpuset_post_attach_flush()
 with cgroup_subsys->post_attach callback
Date: Thu, 21 Apr 2016 19:11:09 -0400
Message-ID: <20160421231109.GK4775@htj.duckdns.org>
References: <20160413094216.GC5774@pathway.suse.cz>
 <20160413183309.GG3676@htj.duckdns.org>
 <20160413192313.GA30260@dhcp22.suse.cz>
 <20160414175055.GA6794@cmpxchg.org>
 <20160415191719.GK12583@htj.duckdns.org>
 <20160417120747.GC21757@dhcp22.suse.cz>
 <20160421230648.GI4775@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=RdgHKoUU7zQPthC9I0R1w3NelYZxyxH4zA92u6kiE6w=;
        b=uz8Qae/fa2fhGdtCFezbn42/4bYkfAQA3chrgCdy7t0kLN7bDNsOx3Laj8NH4uHToO
         kSQX3kdpqdaja4K7Lt9PihYOAK8G1tL6jBzfpLmKm6nk/oxUHromkCFloMPXClQq13Rr
         1MDr7QUjrhf2RS3u39yoSJkf/t0TCsH4PwGW8iXsfqNN+6EXBzMidEMor8AVqIiMcomi
         rOvmyfhJUHOQy1sYyTPi94ZUkNJwL0XznK4ME0WkZVaWIKyuk00vjWQD6TVGxugGJMuy
         teHrNT2w2PmRPMZYCIavmmlahi48c/cKafRuWCA2JPs8m8LlK8Pubj8I+Z1CZm8paFF6
         JZgQ==
Content-Disposition: inline
In-Reply-To: <20160421230648.GI4775-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Cyril Hrubis <chrubis-AlSwsSmVLrQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

BTW, I just got a permanent delivery failure.  The mail was sent out
through gmail.

 Technical details of permanent failure:
 Google tried to deliver your message, but it was rejected by the server for the recipient domain suse.com by prv3-mx.novell.com. [130.57.1.17].

 The error that the other server returned was:
 550 Message was blocked by server (RBL hit)

--
tejun
