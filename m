From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/3] memcg: ratify and consolidate over-charge handling
Date: Mon, 14 Sep 2015 11:51:29 -0400
Message-ID: <20150914155129.GB20047@mtj.duckdns.org>
References: <20150913201416.GC25369@htj.duckdns.org>
 <20150913201442.GD25369@htj.duckdns.org>
 <20150914124420.GE30743@esperanza>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=WOkJUIvMqsBlPN+yNv38L7Akfoqy6iKnr2cE3fvloOM=;
        b=Gb8oz+q4z0ykJuGzuebzhlNIQI5Jbb9zkBmuKr8YqsmlrwYGGN+B+yVbiChCbJ1Tie
         IPIffqmjcIg7XdJ9q+/URT8YBvTT36v5+A9aYAf5ziXjq4DKPmGWFZnsvwCtg0+ivTkw
         RBLUfOetuizU5G4XddE0KjONQeUFIQaNqFxZwrXUTEJaVRF/44b+6I9E9s1jwz2Dyqmu
         jeFg2bVMv5UzwpYo+wiigWfpLcNdmn91A4mE9+qFh9DzZiLEuiFYm0BF+vVGVvZ0jo+s
         6fVoKS69yWMK/uhCuMfEDDrQR8Q/m4ERrey6SnMaUrP+jdMf1KfVFLDGA6AkGUDM6kb6
         007A==
Content-Disposition: inline
In-Reply-To: <20150914124420.GE30743@esperanza>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

Hello, Vladmir.

On Mon, Sep 14, 2015 at 03:44:20PM +0300, Vladimir Davydov wrote:
> Hmm, cancel_charge(root_mem_cgroup) is a no-op. Looks like this is a
> leftover from the times when we did charge root_mem_cgroup.

Yeap, it's inconsistent but not broken.  Will not that in the
description.

Thanks.

-- 
tejun
