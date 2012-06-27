From: Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 02/11] memcg: Reclaim when more than one page needed.
Date: Wed, 27 Jun 2012 09:16:51 -0700
Message-ID: <CABCjUKBJ9UewM=LePC89ZUdk4u4rnZXBNH43yN6qZhT8zcfieQ@mail.gmail.com>
References: <1340633728-12785-1-git-send-email-glommer@parallels.com>
	<1340633728-12785-3-git-send-email-glommer@parallels.com>
	<CABCjUKD0h089StLF8BwVRU-St70Ai9PTw-cjis40_aLLG3MAQQ@mail.gmail.com>
	<4FE9755B.1040905@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:x-system-of-record;
        bh=XrUrjOeiykxIvFd+bAT+a01u8vZUHHPKdV4GF5miR5s=;
        b=dZqYJBYWkEhZe9VhfvOhP5tCLz5nzE/Lyc43OcJZKbdNgr7JbvXXovQec31ymFYhZ9
         CWGGU6m9raJ3yelBQfm11erwAbq2xnUas8q3mnrr4N9j3FbCdLRv3mkPCqFcnDpK9rVw
         Ci/Z3pHFdiJFZk1xUhwJ8y88o0cZEblvO0TQN/udggRnLToMa7Y6zeNGRUU2QkeQpQ92
         IF1jDUywKUAG+J8PJe1KA+yDCrLxo5eg19iI6anKUk2XO/GRWBZyra85/Zkbi0uPpOl4
         bEmnMYbBKAXvoZZLUFqdgqXV5tNidYaoZFG7lJisGDaC3GQYdNKsqvoScUXAmP/y/A0R
         B+cg==
In-Reply-To: <4FE9755B.1040905-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

On Tue, Jun 26, 2012 at 1:39 AM, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org> wrote:
> Yeah, forgot to update the changelog =(
>
> But much more importantly, are you still happy with those changes?

Yes, I am OK with those changes.

Thanks,
-- Suleiman
