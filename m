From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] cgroup: Replace all non-returning strlcpy with strscpy
Date: Mon, 22 May 2023 09:06:39 -1000
Message-ID: <ZGu9P6tqcGIeVD_x@slm.duckdns.org>
References: <20230517144910.1521547-1-azeemshaikh38@gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684782402; x=1687374402;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NXUOmQaA/PPc5IVqYPZz5n5b6S9sKOGW6rscflhON08=;
        b=hTbbdrwFwiFBdH81qUA0luS3Ov5aNfJ0TVKQBneaz5wRyqeQljOfzzMMXNKu7h/5cN
         sAH2etANRA53oFmkUKNfmR4BlZe0ScKlLvn0m1Xkpr6LrvQ0gLX9BPsnV+sRGbDkOMwk
         idJBYBj+8YAYL6Nb/K6mn4aMNHAG6dPI1QQs+fH65X5K4buppSq4G5fEDLEnVLt6cO+R
         1BXD5j+xBttLKonHkqVMfvR1btd3+jHA7lx415wbemH5UZRZGP5LESKci6AXAHlUvYVz
         W9sYnC9SnqYrmy7OJdW9cOLBQLJwVATEDTB5oFfVg4+OU0gS5GMUa3BlDCnXXQ9RqVDJ
         lANg==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20230517144910.1521547-1-azeemshaikh38@gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Azeem Shaikh <azeemshaikh38@gmail.com>
Cc: Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, linux-hardening@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, May 17, 2023 at 02:49:10PM +0000, Azeem Shaikh wrote:
> strlcpy() reads the entire source buffer first.
> This read may exceed the destination size limit.
> This is both inefficient and can lead to linear read
> overflows if a source string is not NUL-terminated [1].
> In an effort to remove strlcpy() completely [2], replace
> strlcpy() here with strscpy().
> No return values were used, so direct replacement is safe.
> 
> [1] https://www.kernel.org/doc/html/latest/process/deprecated.html#strlcpy
> [2] https://github.com/KSPP/linux/issues/89
> 
> Signed-off-by: Azeem Shaikh <azeemshaikh38@gmail.com>

Applied to cgroup/for-6.5.

Thanks.

-- 
tejun
