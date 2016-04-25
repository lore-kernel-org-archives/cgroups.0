From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/2] memcg: relocate charge moving from ->attach to
 ->post_attach
Date: Mon, 25 Apr 2016 15:44:58 -0400
Message-ID: <20160425194458.GH7822@mtj.duckdns.org>
References: <20160413094216.GC5774@pathway.suse.cz>
 <20160413183309.GG3676@htj.duckdns.org>
 <20160413192313.GA30260@dhcp22.suse.cz>
 <20160414175055.GA6794@cmpxchg.org>
 <20160415191719.GK12583@htj.duckdns.org>
 <20160417120747.GC21757@dhcp22.suse.cz>
 <20160421230648.GI4775@htj.duckdns.org>
 <20160421230902.GJ4775@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=eZnpqfzRoy39wnfUFhB1cOs87/gugXAtDKGCZrhvpJU=;
        b=YB1oTT+hg7Fq8Zaib6DI3B4HnHm/HroujcjD5Rp9ieUgn9N1TkS4dVx3/CUGLFRylq
         yYkMS+3tpC9NTK4IBLwygdeZSNTBJtlsqb0XkTScHP6Uph0p8Ryvn8B8Z8MNwbPsS+01
         An2rk2eDuCyl0QinaxMGnz92DYz6XcNJiurIHbkTXbrIqt3HbIplbOyJFqYg8E9rcL6i
         EqW+sFwALHceFDMSos2bH6exuvGTgHRJbZrC6ayuqSqCPLOVj/X9R1h/8H1tGR8Mb7UT
         9bN+lOLMaj/DY7z83J2v6nzfLeRGMVLUOOARkHVPW1kz7RxKneA1AnMtkCUxx6CSh+Kd
         ctdA==
Content-Disposition: inline
In-Reply-To: <20160421230902.GJ4775-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Cyril Hrubis <chrubis-AlSwsSmVLrQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Applied 1-2 to cgroup/for-4.6-fixes.

Thanks.

-- 
tejun
