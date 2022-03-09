From: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 3/3] mm/memcg: add next_mz back if not reclaimed yet
Date: Wed, 9 Mar 2022 00:46:20 +0000
Message-ID: <20220309004620.fgotfh4wsquscbfn@master>
References: <20220308012047.26638-1-richard.weiyang@gmail.com>
 <20220308012047.26638-3-richard.weiyang@gmail.com>
 <YicRNofU+L1cKIQp@dhcp22.suse.cz>
Reply-To: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=3TVdSxpJSiaP4MOwCEb1srbEqP/8itZ5hxFbBSfspVU=;
        b=qfG26zXTlnlLytofDQdjhzVQFVrHlWWJuLEGQbiURbJCyxVT+S/+sCyW4UBw1Tkhr6
         8eI5+5BNaRRo9y4XsorMbX4YHDvCFOnXhpgFVbT9DW60svIIJ/2y6XS7v+wkm1WHOqKg
         WzrT9toQ0hjaXratMNqXPhUbZU9J1602zrv3d78qwPoxlaJfy2RnCJZ4g44NawRFR+ZE
         W4SP4j8s4u0bhDIpF207Pl2laylCjlqPTWxbyoIBw2chodz7bUNsDHAKIVYqEkyA5Rtk
         8Gjh+K1W9qjsBHWp08N13oASyPy8WxzX7E7jr6w3VtPML8CukBoR23hrUXehb/WyQz6D
         GaAA==
Content-Disposition: inline
In-Reply-To: <YicRNofU+L1cKIQp-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Tue, Mar 08, 2022 at 09:17:58AM +0100, Michal Hocko wrote:
>On Tue 08-03-22 01:20:47, Wei Yang wrote:
>> next_mz is removed from rb_tree, let's add it back if no reclaim has
>> been tried.
>
>Could you elaborate more why we need/want this?
>

Per my understanding, we add back the right most node even reclaim makes no
progress, so it is reasonable to add back a node if we didn't get a chance to
do reclaim on it.

It looks like we forget to add it back to the tree. Maybe Johannes know some
background why we don't add it back? 

-- 
Wei Yang
Help you, Help me
