From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [GIT PULL] cgroup changes for v3.6-rc1
Date: Tue, 24 Jul 2012 17:15:10 -0700
Message-ID: <20120725001510.GB5304@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
	h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
	:content-disposition:user-agent;
	bh=4/I5ov7bVNl8MjpRnpu9QSfOt1CQfMl7kCs8IfvBP5M=;
	b=cL/8LgQ+woToE4Nfbf01Ipxcd+CtvV26PhB3h/CObWko3xW11d2+m9QbQO+4OJrlnb
	JKzrkFdF37YFJpyXeiiELQ1PmfXSr6Qg3vSW5DW9L2OhMB/e5qqr2xeTTcHYuXlr8y4v
	l/bKEQD/plWO89Xd6VKO/cX5D3VHc7ORb3RUa3XaoSfRyv4f8RpFrst2LfZDobTW0V8b
	f9T3hBs0495cidubR3balbTU7TBqxeL7PnxlXLcYmb3jSmUuTPtXjykptoAQv0XnAV5I
	hSN2zfLyLCcuOuLOVK77GfErQhjuKEso5mErN1N7OjcRmfQ/itr+2dGAP2sH9rsw9C5G
	OvcQ==
Content-Disposition: inline
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>, 
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, Linus.

Please pull from the following branch to receive cgroup changes for
v3.6-rc1.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-3.6

Nothing too interesting.  A minor bug fix and some cleanups.

Thanks.

Daniel Wagner (2):
      cgroup: Remove populate() documentation
      cgroup: Update remount documentation

Li Zefan (1):
      cgroup: remove hierarchy_mutex

Tejun Heo (1):
      cgroup: cgroup_rm_files() was calling simple_unlink() with the wrong inode

 Documentation/cgroups/cgroups.txt |   27 +++++---------------
 include/linux/cgroup.h            |   17 +-----------
 kernel/cgroup.c                   |   47 +------------------------------------
 3 files changed, 10 insertions(+), 81 deletions(-)

--
tejun
