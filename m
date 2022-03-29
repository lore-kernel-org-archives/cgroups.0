From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH 1/3] mm/memcg: set memcg after css verified and got
 reference
Date: Tue, 29 Mar 2022 14:44:37 -0400
Message-ID: <YkNTlTKnN63r6rWC@cmpxchg.org>
References: <20220225003437.12620-1-richard.weiyang@gmail.com>
 <20220225003437.12620-2-richard.weiyang@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wi+z/Z9+bTszOAA7rHqOmh583Mg3TQkFi7JSYo9ywi0=;
        b=DwNT+z168OYtkjIr+3YCZrHs8/3W8IE1Nl0ty4mFkqoUDo8tf/szSLaUNSBXl4Wylr
         Igz08zwV1POftWtcpP3Bg9dRpjC2RRSOARXxLj9LV4vleyxni2gXse3o/tneb0GkxVR1
         GCA2Y3WWhVwBgW2rUTm8tE1d1SzrbK6SoHglCm6pJffhbfr7ci5KCpwrDi47fafYM6LB
         f57gl5NCEh0wf/vyVx/1AKldB1o0JblAPOMNQRGw5UgkzN55gvhp7EEEhbwNIrdlMBHv
         5E/5+odSEQc2tVHazcmLF2OlWqY0zC5BtLU0iJ4rJiBNMb65yV12mTS9BjnBpF8yy3S/
         5QOw==
Content-Disposition: inline
In-Reply-To: <20220225003437.12620-2-richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Fri, Feb 25, 2022 at 12:34:35AM +0000, Wei Yang wrote:
> Instead of reset memcg when css is either not verified or not got
> reference, we can set it after these process.
> 
> No functional change, just simplified the code a little.
> 
> Signed-off-by: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

This looks better indeed.

Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
