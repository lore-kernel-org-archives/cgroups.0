From: Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v12 9/9] hugetlb_cgroup: Add hugetlb_cgroup reservation docs
Date: Wed, 19 Feb 2020 16:03:29 -0800
Message-ID: <CAHS8izPfaq=rfUrQGDyOwbgZhw96Qbos9xAdJzs35KyLB_JZ-A@mail.gmail.com>
References: <20200211213128.73302-1-almasrymina@google.com> <20200211213128.73302-9-almasrymina@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YHeIdmxOoP0hF/CsX1z22j/VcXTF+m2n9SPCMuF9eo0=;
        b=Q0qIGLPNuwluFhVMJjoUI0Nx6z7pyTSN7DOfAsbF6qO5OaYP+p/1yvW2zX1CgLr2HR
         K0OgeL1DtnewH8OGFkdUlXrehmNjgUiIXmJO2aiXfD6jEWvT99CQpYWm9279KjIQ4rbC
         Ya0A4bWv87EWS8lzBJ0Q7f88+9UwlAhD77pFZTnGu/UdG670VRiS2sIULtT46781IhuI
         YbiRP83N+GEklKllMDq1Vek5xCN/2MVOULroAXTqfgQk29icTjdS+Vg05p3ZdJgbNefK
         Z73ntL+t70lQkgEHoyThAMI7NElrteSsI7AX1PvyU62Z0Q5z5sqdYuGQTfs1sARnFNO2
         vIgQ==
In-Reply-To: <20200211213128.73302-9-almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mike Kravetz <mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: shuah <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Feb 11, 2020 at 1:32 PM Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>
> Add docs for how to use hugetlb_cgroup reservations, and their behavior.
>
> Signed-off-by: Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>

Hi folks,

By my count this patch and the tests are the only patches in the
series awaiting review. Can you folks give it a look?

Thanks in advance!
