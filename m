From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 1/4] kernfs: kvmalloc xattr value instead of kmalloc
Date: Mon, 9 Mar 2020 16:05:34 -0400
Message-ID: <20200309200534.GA79873@mtj.duckdns.org>
References: <C16IH7NEXW4J.440OGTNY7CWX@dlxu-fedora-R90QNFJV>
 <6bbfc8b8c9c206d80de43a64bfe4b8083cc2c02f.camel@perches.com>
 <20200309195104.GA77841@mtj.thefacebook.com>
 <84ef5548ee27e7150d0b7a5702ce50536cea975a.camel@perches.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+ZjW9cfDpa/bATgR4gQIdFs9uH7Dsn2IXM1Pc8dEvAU=;
        b=Jl5GP4mafSZXODnON2fziI+zRq75X3kZPaB00uliiygLfB+5WbqPjzKgph4Taznw+F
         El6NAvSi9cgaXMa70CWtVT6bzlSKRFYEWOqw1KD9r4khD3tNh2kjs1jW/67LEeS2Kd3P
         wp7d9Pyj5Z8ESZLUcDLqZ1dB9LELTPTC7Zv7hrFWiCsxu/mVToq8pTVPLa9bJx5Jx6ZT
         BJrINld4wiMNzV3pbhwgcl5OnzQJvyI0b3iUiUl7Hcq900ZzQ635ANXTUo6t55i0dVc1
         EcKWNkBKANRaCHXbD41dacsGCSusl4myYtRNnZrDFFCDtT20rkXucetpXPMD/4NJrkHy
         Trww==
Content-Disposition: inline
In-Reply-To: <84ef5548ee27e7150d0b7a5702ce50536cea975a.camel-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
Cc: Daniel Xu <dxu-zUS5+7O8QwqlVyrhU4qvOw@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Mon, Mar 09, 2020 at 12:58:49PM -0700, Joe Perches wrote:
> This feels like driving spikes into a living thing
> more than into a
> corpse.
> 
> I've still got more than a few 32-bit devices around.

Unless you're suggesting we stop using vmallocs altogether, I don't
see how your objection makes sense here.

-- 
tejun
