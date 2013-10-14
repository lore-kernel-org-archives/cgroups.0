From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2] blk-throttle: simplify logic by token bucket algorithm
Date: Mon, 14 Oct 2013 09:59:29 -0400
Message-ID: <20131014135929.GH4722@htj.dyndns.org>
References: <1381574794-7639-1-git-send-email-zhiguohong@tencent.com>
 <1381741757-20888-1-git-send-email-zhiguohong@tencent.com>
 <20131014133620.GF4722@htj.dyndns.org>
 <CAA7+ByWPM2Pizm+dP1AxPM7Ut-w=AtRfD2GkCK-0OVh+C2Twkg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=fzejRZR4V7Sp8k45D/kmxhHIu/pGZOF7XAUyo6X2vnw=;
        b=Cd60lWUDfhu11CKJ5gEdbkmJjhe4pqTXGxu9/1icrPAFGdHjtZ/w9GK6nH/Rvhyjm3
         EZ9MffGw0YoZaHc9eL8afODbSJsYxIx2zVd8sLT+ftYQ+XR73snu0Cd9CsWazNJAiBfE
         eeq4qMqFuTp32ideUvU4zYMkIf7SxzbwI/TSzHy7FAop6ga/AgS5bSzcY+UTG3Pda/Mg
         ec0l7EoCk5tLRyrpVrbwdFzWj5Y2QK1z/BRHa3uyd6ZH/SzVEjJIQQDsoJgFUZuIERW0
         AsZLAcb7wSI+7BKE1XvdCXKZS4nCN5evXZTBYU0jWbXH2wMQ+nBqUaLa4HlKZlQV1C/t
         FMRA==
Content-Disposition: inline
In-Reply-To: <CAA7+ByWPM2Pizm+dP1AxPM7Ut-w=AtRfD2GkCK-0OVh+C2Twkg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hong zhi guo <honkiko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Hong Zhiguo <zhiguohong-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>

On Mon, Oct 14, 2013 at 09:53:54PM +0800, Hong zhi guo wrote:
> I've not tested hierarchical setup yet. I'll do it tomorrow.
> BTW, what kind of setup do you expect? Is hierarchy of 2 levels enough?

That should cover most of the functionalities but going for 3 levels
can't hurt, right?

Thanks.

-- 
tejun
