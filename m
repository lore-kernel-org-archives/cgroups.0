From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH v4 3/6] cgroup: refactor fork helpers
Date: Mon, 20 Jan 2020 15:00:30 +0100
Message-ID: <20200120140029.GB30403@redhat.com>
References: <20200117181219.14542-1-christian.brauner@ubuntu.com>
 <20200117181219.14542-4-christian.brauner@ubuntu.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579528837;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YmtsJvNikQZ3zxiH/9D0rl/gNwQCHBkjzEkFAg43zNQ=;
        b=EcviU5z+o0JmkNHYPQcmsJSg+yK5uLh4g/WsalIhOt+Hw6iFVMQPfO/G6uiYn3DIoFte4x
        Q7KUBO+Otlxp/0LEzv4SKWlxicF75DMP3HeHei60y7ecf8klaurQXPsrUrlVmBN/HczDU9
        jODMPqWUoYWZ7eE51y9sM3L/V5/1KCA=
Content-Disposition: inline
In-Reply-To: <20200117181219.14542-4-christian.brauner@ubuntu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christian Brauner <christian.brauner@ubuntu.com>
Cc: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Li Zefan <lizefan@huawei.com>, cgroups@vger.kernel.org

This is probably the only patch in series I can understand ;)

To me it looks like a good cleanup regardless, but

On 01/17, Christian Brauner wrote:
>
> The patch just passes in the parent task_struct

For what? "parent" is always "current", no?

Oleg.

