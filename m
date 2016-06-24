From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] capabilities: add capability cgroup controller
Date: Fri, 24 Jun 2016 11:48:30 -0400
Message-ID: <20160624154830.GX3262@mtj.duckdns.org>
References: <1466694434-1420-1-git-send-email-toiwoton@gmail.com>
 <20160623213819.GP3262@mtj.duckdns.org>
 <53377cda-9afe-dad4-6bbb-26affd64cb3a@gmail.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=4An1VTLM+WcfzMPr+Tji5ZqLHnlf3SdRKgKn9n96aMQ=;
        b=0wRp0FXqi92nVv1iXu8Ocg80quH0HUoZb3EHp1f05LbfUNIKjEKMjqKo1F3x8uSe9H
         Iip5YNYfVnxXDbgrGv8ELfGcSyVR2PHe6u8zhKDNKEPP+vFbJH8xqA0m6jEI+Xq3Zk+U
         gExATX7+awXtSw9xPpe82eZSZ/kHA7W7X384uR/OUFUv4PgBCKuroQVr9umBDLJV/dq4
         2CxuVqncDZ2ndI8JR5V19sFE+Pe/C9taR6nmPeSmBH0OFUX6ltXMH+yc8OMT04Yjn/Vu
         2O3WXQriCsDiL9BrXJMtwNRwYTVUEphyWrUw8v/H8MaGe6+c6iyiWE9bE2klfNZJ8e5S
         7aYg==
Content-Disposition: inline
In-Reply-To: <53377cda-9afe-dad4-6bbb-26affd64cb3a@gmail.com>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Topi Miettinen <toiwoton@gmail.com>
Cc: linux-kernel@vger.kernel.org, luto@kernel.org, serge@hallyn.com, keescook@chromium.org, Jonathan Corbet <corbet@lwn.net>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Serge Hallyn <serge.hallyn@canonical.com>, James Morris <james.l.morris@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, David Howells <dhowells@redhat.com>, David Woodhouse <David.Woodhouse@intel.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Petr Mladek <pmladek@suse.com>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>, "open list:CAPABILITIES" <linux-security-module@vger.kernel.org>

Hello,

On Fri, Jun 24, 2016 at 12:22:54AM +0000, Topi Miettinen wrote:
> > This doesn't have anything to do with resource control and I don't
> > think it's a good idea to add arbitrary monitoring mechanisms to
> > cgroup just because it's easy to add interface there.  Given that
> > capabilities are inherited and modified through the process hierarchy,
> > shouldn't this be part of that?
> 
> With per process tracking, it's easy to miss if a short-lived process
> exercised capabilities. Especially with ambient capabilities, the parent
> process could be a shell script which might not use capabilities at all,
> but its children do the heavy lifting.

But isn't being recursive orthogonal to using cgroup?  Why not account
usages recursively along the process hierarchy?  Capabilities don't
have much to do with cgroup but everything with process hierarchy.
That's how they're distributed and modified.  If monitoring their
usages is necessary, it makes sense to do it in the same structure.

Thanks.

-- 
tejun
