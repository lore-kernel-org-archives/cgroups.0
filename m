From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/2] cgroup: Check for ret during cgroup1_base_files cft
 addition
Date: Mon, 18 Sep 2023 08:57:49 -1000
Message-ID: <ZQidrVijM8g6tdBC@slm.duckdns.org>
References: <96694dfc5f4caf4d84a740c3b18b0a456c9ff522.1694501024.git.kamalesh.babulal@oracle.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695063471; x=1695668271; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LQDoCkknityzKxYLZnoGn22QkefMP1I66BO9eL96RWg=;
        b=DX44+TkfJEkrRIvfFqd9Zdwn5DZ8gInosV7cROO0uElsTlCV89+H7JT4Pbul457jZT
         EMXQysi1yJjdUQeFd644wJUDCohAlNJ1mT0lxoQhiJwvxjJeQDcJgplo3PBJTSA1iI9G
         3btEyg8x2EsG9AeJ3jphxKuhPtZlRETAj00qOpiT1TC8lFrytHT7ObcJgEPf4PSp8XJ9
         CzgE6tVmncuHlDpcon+jLI7id6Ld14Pyi5R+WO6bqlWNVpBo9Tu0IBMNyr5AD5G8DBbU
         qvPCEbi3bmusYMJ/ceFgnSd07mJmmTfkFkUlr6tBLcafMNb1zJbPSYwuil24+HzjQHzw
         Bv7w==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <96694dfc5f4caf4d84a740c3b18b0a456c9ff522.1694501024.git.kamalesh.babulal-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kamalesh Babulal <kamalesh.babulal-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tom Hromatka <tom.hromatka-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Sep 12, 2023 at 12:34:34PM +0530, Kamalesh Babulal wrote:
> There is no check for possible failure while populating
> cgroup1_base_files cft in css_populate_dir(), like its cgroup v2 counter
> parts cgroup_{base,psi}_files.  In case of failure, the cgroup might not
> be set up right.  Add ret value check to return on failure.
> 
> Signed-off-by: Kamalesh Babulal <kamalesh.babulal-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

Applied to cgroup/for-6.7 with double spaces removed.

Thanks.

-- 
tejun
