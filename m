From: Thomas Graf <tgraf@suug.ch>
Subject: Re: [PATCH v6 5/6] net: ipv4, ipv6: run cgroup eBPF egress programs
Date: Wed, 21 Sep 2016 20:48:27 +0200
Message-ID: <20160921184827.GA15732@pox.localdomain>
References: <1474303441-3745-1-git-send-email-daniel@zonque.org>
 <1474303441-3745-6-git-send-email-daniel@zonque.org>
 <20160919191910.GA984@salvia>
 <ac88bb4c-ab7c-1f74-c7fd-79e523b50ae4@zonque.org>
 <20160919203533.GA888@salvia>
 <83afdc54-1bbe-3530-e5fd-b74fefe9a042@zonque.org>
 <20160920142931.GA31438@salvia>
 <6584b975-fa3e-8d98-f0c7-a2c6b194b2b6@zonque.org>
 <20160921154533.GA13656@salvia>
Mime-Version: 1.0
Return-path: <netdev-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suug-ch.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=4cPxQBsJ2G33W7QLxErmj1VgToAIB3aPyMj+Db2gtEw=;
        b=M19/Q7ZvtlFHwJrtbIccCYd5glYF3JMlFcYHqUXrDeMZwAu6f0OI0I0VN8M7MN4+2o
         ex2+pIBvU2ouYK6BwRRbjwhT4MUWUi94BZSkW2uGVCfcAdZO9TMp/f6vxej8c95SKGLq
         ohVlMY9jPG2ucJdUld3rqLvwEZALBZNyeq2CrLyvm8u1tJZcmv5QsObupD/u26l4Oa9G
         C4mv4VUb4hbXS1nJELIjKJ3lA0y/m5ZqT6vvJ2TK5ZetMBywhkdi6BFcEumMLuD3DU6g
         CbnTauhfh6NhMmnmm9Jri0cmZ1LiJbhSwHXi+uqOeEIMs2b70uOoYBkwlUWEEI+NUICg
         Tpyw==
Content-Disposition: inline
In-Reply-To: <20160921154533.GA13656@salvia>
Sender: netdev-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Daniel Mack <daniel@zonque.org>, htejun@fb.com, daniel@iogearbox.net, ast@fb.com, davem@davemloft.net, kafai@fb.com, fw@strlen.de, harald@redhat.com, netdev@vger.kernel.org, sargun@sargun.me, cgroups@vger.kernel.org

On 09/21/16 at 05:45pm, Pablo Neira Ayuso wrote:
> On Tue, Sep 20, 2016 at 06:43:35PM +0200, Daniel Mack wrote:
> > The point is that from an application's perspective, restricting the
> > ability to bind a port and dropping packets that are being sent is a
> > very different thing. Applications will start to behave differently if
> > they can't bind to a port, and that's something we do not want to happen.
> 
> What is exactly the problem? Applications are not checking for return
> value from bind? They should be fixed. If you want to collect
> statistics, I see no reason why you couldn't collect them for every
> EACCESS on each bind() call.

It's not about applications not checking the return value of bind().
Unfortunately, many applications (or the respective libraries they use)
retry on connect() failure but handle bind() errors as a hard failure
and exit. Yes, it's an application or library bug but these
applications have very specific exceptions how something fails.
Sometimes even going from drop to RST will break applications.

Paranoia speaking: by returning errors where no error was returned
before, undefined behaviour occurs. In Murphy speak: things break.

This is given and we can't fix it from the kernel side. Returning at
system call level has many benefits but it's not always an option.

Adding the late hook does not prevent filtering at socket layer to
also be added. I think we need both.
