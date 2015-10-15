From: "Robert Gierzinger" <robert.gierzinger-RbZlAiThDcE@public.gmane.org>
Subject: cgroup pid controller side effects
Date: Thu, 15 Oct 2015 16:13:02 +0200
Message-ID: <f2e-561fb480-9-1b99f780@25775614>
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=gmx.at; s=mail;
	t=1444918382; bh=MrDstLan9GAh3LgK3wTMqwsQhlg6RV7ZByqyYquG7hs=;
	h=from:date:subject:to:From:Sender:To:CC:Subject:Date;
	b=GOY/BipoEb2LYkWDl8Fr6C06rRVxrJPATB9hVqPfioM1zDdYRD5QJdso0LdDBQtIq
	 guA3xgByPVE7w/qqOcknuT9i3ONB7ABsc3VInQtmnyWGrD2ErPbZauqd26b8aFRBSA
	 ECHcMwBGLIzASwoJ7tOyA/0LEQYJmO8h5zh7AQWjQaAGFiMfUMXvTN8goDbfFjgomo
	 2BRX05YE/dySXEv0fvKCbs+cG4PmAaDWEWyX0GTBjQPuf0kodZituA5Hodum7JUBR6
	 jjZbzsAwcVh19lchg3TX+IyW8bfNYQFPcP0M56EexKG0mhn/7TZYnz/y7WMSOm6BBU
	 Aza6nJujIC4rA==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,
I have finally had time to test 4.3-rc5 especially (my greatly anticipated) process limitiation with cgroup-pids.
With bash forkbombs, it really works nice, however, I had some side effects with the forkbomb from
https://github.com/linux-vserver/util-vserver/blob/master/tests/forkbomb.c

The good thing: my test systems did not die as in previous versions during the simulated attack. But executing the file with e.g. 
./forkbomb 100000 100 fork
I get "unable to fork process: Resource temporarily unavailable" on the host (e.g. while trying to have a look via "watch -n 2 cat /sys/fs/cgroup/pids/lxc/dev04/pids.current") and inside other cgroup processes. This happens with various (low) limits in the respective pids.max; also it doesn't matter whether to launch the forkbomb in a privileged or unprivileged/user-namespace cgroup.

Maybe someone could have a look, please, as this would be a real nice feature for a hosting service.
And thanks for your great work!

Best regards,

Robert
