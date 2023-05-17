From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH] cgroup: Replace all non-returning strlcpy with strscpy
Date: Wed, 17 May 2023 12:14:24 -0700
Message-ID: <202305171214.C6B93E6A5@keescook>
References: <20230517144910.1521547-1-azeemshaikh38@gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1684350865; x=1686942865;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/Dlq/LhLdjBBa7rEoCSYP9M1ozuA1zyVPiangWQIFMI=;
        b=eIEE4i1XP1pkhSnVGQGWgRG8pI2jWOJ+cKID0bS4SWjSUNZSszxmLvKlYs83DOtNvF
         euc4WHz7O5H4eJswSX2r5tdLaLH69xWiwS8HTiIeB29IE9ymKTPasc6OezkZ8HLw3gkU
         O+NPk9Cn9iplJ8RJdF7qBi4aBY7UTxCuj4pMQ=
Content-Disposition: inline
In-Reply-To: <20230517144910.1521547-1-azeemshaikh38@gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Azeem Shaikh <azeemshaikh38@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, linux-hardening@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

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

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
