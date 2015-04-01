From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v7 0/4] cgroups: add pids subsystem
Date: Tue, 31 Mar 2015 22:40:55 -0400
Message-ID: <20150401024055.GK9974@htj.duckdns.org>
References: <1427855490-5280-1-git-send-email-cyphar@cyphar.com>
 <CAOviyahS_PsKxYzePEorpRYDq+0=Ttw+ZLkAH0r+eEuxy5uM+Q@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=XmB7lF40z6gF77wyYhVZU4FsdJ7D+7sWu4zMQrJwaDs=;
        b=s0gr0qoAfcNNRDcnB4PeCA4AZlHDJRhRSWfTiimFMYl5pCrDXoEkvuX1bLxzERluaN
         yYGJvQbQsVhy8OWlfNA8Hqcta8clcGYIVUUn6N7ghmYhUjY6Lilb4aVQYq6d7tEglPD+
         3UJ+LerxbIi0HWGAkYsDdGtmbEgh8kdiZ6BX32QkDXPhMDqGof4qByDFdV0IifMoY8LF
         XLc1AQfYHnxcREowKhows6lil8ZPWZEBqzqFQ+X9eRjV5Ho91yvd6L3VBpVZngQ+4oM5
         1wU8aO2xuGWlPyRDGpdovnOg86K7eYCvRgF1Ur1zGoDgJ9ZXBsAJWQcQha5wzOjkIe+6
         nIhA==
Content-Disposition: inline
In-Reply-To: <CAOviyahS_PsKxYzePEorpRYDq+0=Ttw+ZLkAH0r+eEuxy5uM+Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, richard-/L3Ra7n9ekc@public.gmane.org, =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Apr 01, 2015 at 01:36:06PM +1100, Aleksa Sarai wrote:
> Hi Tejun,
> 
> I decided to send out this version of the patchset (that has the additional
> callback, and passes around an opaque "fork state" inside the copy_process()
> callback), because I personally prefer this version of the patchset (it's much
> cleaner and doesn't mess around with the fork() callback for no good reason).
> If you *really* want the other one, I can send it.

Yes, please.

-- 
tejun
