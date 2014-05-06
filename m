From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 2/4] cgroup: only allow space as the separator for "cgroup.subtree_control"
Date: Tue,  6 May 2014 07:50:42 -0400
Message-ID: <1399377044-29873-3-git-send-email-tj@kernel.org>
References: <1399377044-29873-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=mJXEscHiUIYYaMNMVTfRtU/uQqQlcmqzbLty5xBRfJM=;
        b=0pYaKVXNEoT8l66mdP0HJ42UNllpxLeLKQiszdLGfyxe+bOxcfzt1W1+kV/o1Jjt6i
         JXR+L/4c1CY4pB8ZZFXwqPmoz6w3LxVyKRugUbqnzXdubzMXp7mwj9qTeyXrd+83LdbV
         h+gF9Uls7uI3tuK0NXUOsJKUZFqr0gUpHjT/2ced5LLM1t2t1p9rEnw9DOY5SktVLyhy
         6H0wDjNfjSj/UM2tqsKHYidmBllkzMZV0QJcVAImUSTMqOXF16lHJprXj3dLidV2mikM
         muN6wZ/BPAKZpoxxljaLukHKhcQhaOLgJWXbJvoTuPJdpdmnKUOllrUQDU12THXVbYJB
         o2Ww==
In-Reply-To: <1399377044-29873-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>

I was confused that strsep() was equivalent to strtok_r() in skipping
over consecutive delimiters.  strsep() just splits at the first
occurrence of one of the delimiters which makes the parsing very
inflexible, which makes allowing multiple whitespace chars as
delimters kinda moot.  Let's just be consistently strict and require
list of tokens separated by a single space.  This is what
Documentation/cgroups/unified-hierarchy.txt describes too.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 54fd12d..9066fe9 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2542,11 +2542,11 @@ static int cgroup_subtree_control_write(struct cgroup_subsys_state *dummy_css,
 	int ssid, ret;
 
 	/*
-	 * Parse input - white space separated list of subsystem names
-	 * prefixed with either + or -.
+	 * Parse input - space separated list of subsystem names prefixed
+	 * with either + or -.
 	 */
 	p = buffer;
-	while ((tok = strsep(&p, " \t\n"))) {
+	while ((tok = strsep(&p, " "))) {
 		for_each_subsys(ss, ssid) {
 			if (ss->disabled || strcmp(tok + 1, ss->name))
 				continue;
-- 
1.9.0
