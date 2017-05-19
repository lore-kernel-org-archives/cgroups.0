From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 06/31] cgroup-v2.txt: standardize document format
Date: Fri, 19 May 2017 10:59:21 -0400
Message-ID: <20170519145921.GB7174@wtj.duckdns.org>
References: <cover.1495156488.git.mchehab@s-opensource.com>
 <1f0804f2263073287d2a106c12f88f295a30cec5.1495156488.git.mchehab@s-opensource.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=bqLjw3MUFr9cY11Uh/xFKiC36fsUNAOv0k9xP39Q2Co=;
        b=DWKDYRDZ/Q0xk/9oLkvb2hE+iAc+l+alClhFhYhSFKMjDAcewG7ZUDSBhH5u3k03xY
         NTnDpIS8SJxFKvjEJComvkUjad+5DCTfv1L1QIZz272ypFFUapplb4dJwZ1c5Fny45if
         pQ5urOdpMfczzYRcBf4LfbNpwvyblrspf2O6olonug5Dnw+iiOPhDlHZPZDh4OqVRWdh
         UBjgoDVGYjq1MlLrRMWM8XDvBhtQxFTM+Kn7Yc3wx3fuPg8HU/6Qrkpr4XLLtVx/7T4P
         A2+cdxSRqqGipS2qAMws/ukqtRa6I9NQswvbYC/8l0RlpGK4DFoEAJMxxiMcfcBdd5tY
         JJuA==
Content-Disposition: inline
In-Reply-To: <1f0804f2263073287d2a106c12f88f295a30cec5.1495156488.git.mchehab-JsYNTwtnfakRB7SZvlqPiA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mauro Carvalho Chehab <mchehab-JsYNTwtnfakRB7SZvlqPiA@public.gmane.org>
Cc: Linux Doc Mailing List <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mauro Carvalho Chehab <mchehab-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Brian Norris <computersforpeace-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Boris Brezillon <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, Marek Vasut <marek.vasut-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Cyrille Pitchen <cyrille.pitchen-AIFe0yeh4nAAvxtiuMwx3w@public.gmane.org>, linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, Mauro.

On Thu, May 18, 2017 at 10:22:11PM -0300, Mauro Carvalho Chehab wrote:
> Each text file under Documentation follows a different
> format. Some doesn't even have titles!
> 
> Change its representation to follow the adopted standard,
> using ReST markups for it to be parseable by Sphinx:
> 
> - Comment the internal index;
> - Use :Date: and :Author: for authorship;
> - Mark titles;
> - Mark literal blocks;
> - Adjust witespaces;
> - Mark notes;
> - Use table notation for the existing tables.

If this is the direction we're taking for all docs, looks good to me.
Do you want me to take the patch through the cgroup tree?

Thanks.

-- 
tejun
