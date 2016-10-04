From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC][PATCH 0/2] Another pass at Android style loosening of
 cgroup attach permissions
Date: Tue, 4 Oct 2016 16:33:01 -0400
Message-ID: <20161004203301.GK4205@htj.duckdns.org>
References: <1475556090-6278-1-git-send-email-john.stultz@linaro.org>
 <20161004161630.GC4205@htj.duckdns.org>
 <CALAqxLUPMxpngbZCSFW9wS+LbZJbfSUxTDEXX2x-FUmuN4H+QQ@mail.gmail.com>
 <20161004193838.GH4205@htj.duckdns.org>
 <20161004201840.GA27018@mail.hallyn.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=AXS26UsMjZdONjxdArJvFPg4QGcV4Hunb2DGVoYCyl4=;
        b=CCugzhnNSxEbxwgDtmvG1XZ59Xawgb9q0AZPy0b0y7Tx7ubpfMGqyCvWpokQMC5r+l
         h7+DL0bD0+0i1vrYI2yz8cnpb5Y9HsnEgZM7YL6BZe2THCD9bikF8dDubkS2ssvbA/To
         oxsuueQqMZslUfcWHENxoicgqltdQW9WZJLaMIMiEqdh+AeZcNwoHd8cIOLkjHqYfNy7
         pI0aewSfesGuH5Nx+uJxM1tNdt6SorLgaVmlAeOeFVQaacv+ahZAcJYUvhaFLtsUVQoC
         UXDfI6n8oe3wN39dQO4TIwKoOKc8R+RMEJgxgdfGdVkjg4DH1bwyjpINLSPx4j6WePOA
         UbTw==
Content-Disposition: inline
In-Reply-To: <20161004201840.GA27018@mail.hallyn.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: John Stultz <john.stultz@linaro.org>, lkml <linux-kernel@vger.kernel.org>, Li Zefan <lizefan@huawei.com>, Jonathan Corbet <corbet@lwn.net>, cgroups@vger.kernel.org, Android Kernel Team <kernel-team@android.com>, Rom Lemarchand <romlem@android.com>, Colin Cross <ccross@android.com>, Dmitry Shmidt <dimitrysh@google.com>, Todd Kjos <tkjos@google.com>, Christian Poetzsch <christian.potzsch@imgtec.com>, Amit Pundir <amit.pundir@linaro.org>

Hello, Serge.

On Tue, Oct 04, 2016 at 03:18:40PM -0500, Serge E. Hallyn wrote:
> how about changing the GLOBAL_ROOT_UID check with a targeted
> capability check, like
> 
> 	if (!ns_capable(tcred->user_ns, CAP_SYS_NICE) &&
>             !uid_eq(cred->euid, tcred->uid) &&
>             !uid_eq(cred->euid, tcred->suid))
> 		ret = -EACCES;
> 
> where the actual capability to use may require some thought.

Yeah, that's the direction I'm thinking too.  We can't use
CAP_SYS_NICE in general tho.  Let's see if a dedicated CAP sticks.

Thanks.

-- 
tejun
