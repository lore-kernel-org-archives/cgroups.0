From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 0/3] cpuset: Allow setscheduler regardless of
 manipulated task
Date: Mon, 10 Jul 2023 10:30:14 -1000
Message-ID: <ZKxqVvgh_ccdR0Lj@slm.duckdns.org>
References: <20230703172741.25392-1-mkoutny@suse.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689021017; x=1691613017;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cKmlv+wxXqaSoHkhgo1UfUl18TmiO3xK9oBQKtdH8iQ=;
        b=KHal0/ZUL6wMKbvmzzrwC7IC3NNlsfwGTHYhP6y+gItbJTQGgjsXOdqklPgg5cEymE
         fSGru2UrWEvmO4KeaEK2ywvhLz8TAHwz+wfx8Uw+5pbZlTWhnsHXWfqdwJMMkVTn1GvU
         IoP7cVUFi5tMbwJj+WEfkrps1JDOx9mXKTmdYVKay7fbTuzLVSEXqjA3KeUtec1c0lsy
         MW9I2g4Y2jdbfJpbYHcaSZoz+mNcAbJpumNbTZnnW0X08WAjGOMVTSipoVJjmaLTPAky
         bcN1fqypBgny8jHWYvIw787G+Iq9+nZBfqKP/tgVgTZWEYxYBGx5iYw9z8A7VOiVbzkf
         cE1A==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20230703172741.25392-1-mkoutny-IBi9RG/b67k@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Applied to cgroup/for-6.6.

Thanks.

-- 
tejun
