From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v8 3/4] cgroups: allow a cgroup subsystem to reject a fork
Date: Mon, 6 Apr 2015 11:05:36 -0400
Message-ID: <20150406150536.GA10582@htj.duckdns.org>
References: <1427878641-5273-1-git-send-email-cyphar@cyphar.com>
 <1427878641-5273-4-git-send-email-cyphar@cyphar.com>
 <20150401160258.GP9974@htj.duckdns.org>
 <CAOviyai9dvCTGK=VUm0uDSo7XbmKk1BFDrRzL15ppAWf8YjG3w@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=cSvlPapurUNwaGsyIeFT8uMq8UHzrcQZqS0NEdHtRR4=;
        b=SjEHtyIfJKWLcepXT5aMGJ9GFRjapTIgrcSpfo+q4Ho0vuhRPb+KJtFkddXoEQ0jFx
         HGlP6RwKkJTWxUpAChmXaCObGotVeeU67Ezxj8RANn1yaQAaPDv4ME5HnDYUlhbUKmzX
         dkyC2ic/67CpHphQosq96/UoesK5rnz1nWdfk24hXKmuygmN7PI4OGW6yCb+wmJYsrmy
         yZP3mIsKiMvXArHQILnLqYyBlnTQC0Uk2u28OnfH74yTBK6W1R+MHZ+3qDJPfIEIofjB
         1MNvyobJTEyUv9o6oTaaj7cBFociHst9YZ7FUrYKVegJvDfJucGu5qri21HHHYRre0ga
         l87Q==
Content-Disposition: inline
In-Reply-To: <CAOviyai9dvCTGK=VUm0uDSo7XbmKk1BFDrRzL15ppAWf8YjG3w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, richard-/L3Ra7n9ekc@public.gmane.org, =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, Aleksa.

On Fri, Apr 03, 2015 at 10:42:27AM +1100, Aleksa Sarai wrote:
> I tried doing this and the kernel would refuse to boot. I believe it has
> something to do with the ordering of early_init subsystems, but I'm not

Hmmm... yeah, failure in early_init can be tricky to debug.

> entirely sure (this optimisation can be dealt with later [it's non-critical],
> so IMO this should be done in a separate patchset [if at all]). Also, your
> later comments would fix the subsys bitmask problem (we can just pass the
> default %NULL), we don't even need to test the index.

But we'd be adding quite a few loops in relatively hot paths.  I don't
think it's a good idea to send the patches as-are because we can't
debug and fix them properly, right?  If there are hard ordering
dependencies, the range of subsystems which require fork/exit doesn't
have to be at the beginning.

Thanks.

-- 
tejun
