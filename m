From: Marian Marinov <mm-l-NV7Lj0SOnH0@public.gmane.org>
Subject: RFC: sysctl fixes
Date: Thu, 05 Mar 2015 16:43:56 +0200
Message-ID: <54F86BAC.1060902@yuhu.biz>
References: <54F7061B.80002@yuhu.biz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54F7061B.80002-NV7Lj0SOnH0@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,
we are running hundreds of containers and we got some valid requests from customers that want to be able to change their
container's hostname using the sysctl command.

The current implementation does not allow each UTS namespace to change its own hostname.

So we sponsored the development of fix for this issue.

Please checkout the changes here:
  https://github.com/1HLtd/linux/compare/b24e2bdde4af656bb0679a101265ebb8f8735d3c...sysctl-hostname-fixes

If this fix is acceptable I'll send the patches as it is common. But first I want to know if you think this is the way
to go.

Thank you,
Marian



